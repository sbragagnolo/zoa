"
I am a visitor on springer domain
"
Class {
	#name : #ZoaSpringerVisitor,
	#superclass : #ZoaHTMLVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaSpringerVisitor >> isAbstract: anElement [

	^ self element: anElement isType: 'section' andClass: 'Abstract'
]

{ #category : #visiting }
ZoaSpringerVisitor >> isContributorArea: anElement [

	^ self
		  element: anElement
		  isType: 'div'
		  andClass: 'authors-affiliations u-interface'
]

{ #category : #testing }
ZoaSpringerVisitor >> isDateReference: anElement [

	^ self
		  element: anElement
		  isType: 'span'
		  andClass: 'article-dates__first-online'
]

{ #category : #visiting }
ZoaSpringerVisitor >> isKeywordsArea: anElement [

	^ self element: anElement isType: 'div' andClass: 'KeywordGroup'
]

{ #category : #visiting }
ZoaSpringerVisitor >> isReference: anElement [

	^ self element: anElement isType: 'div' andClass: 'CitationContent'
	
]

{ #category : #visiting }
ZoaSpringerVisitor >> isTitle: anElement [

	^ self element: anElement isType: 'h1' andClass: 'ChapterTitle'

]

{ #category : #visiting }
ZoaSpringerVisitor >> processAbstract: anElement [

	| abstract |
	"A Springer abstract can be made of a single string node, or by many paragraphs with style.
	Extract just a string from it."
	
	abstract := String streamContents: [ :stream |
		"Skip the abstract title"
		anElement nodes allButFirst do: [ :elem |
			"For each element besides the title, iterate the tree and extract the strings"
			elem allElementsDo: [ :subelem |
				subelem stringNodesDo: [ :stringNode | 
					stream nextPutAll: stringNode string ] ] ] ].

	article abstract: abstract.
]

{ #category : #visiting }
ZoaSpringerVisitor >> processContributorArea: anElement [

	| affiliations |
	affiliations := Dictionary new.

	self assert: anElement nodes first name = 'ul'.
	self assert: anElement nodes second name = 'ol'.


	anElement nodes second nodes do: [ :n | 
		self assert:
			((n nodes first attributeAt: 'class' ifAbsent: '') 
				 includesSubstring: 'affiliation__count').
		self assert: ((n nodes second attributeAt: 'class' ifAbsent: '') 
				 includesSubstring: 'affiliation__item').
		affiliations
			at: (n nodes first nodes first asString readStream upTo: $.)
			put: n nodes second nodes first nodes first asString ].
	anElement nodes first nodes do: [ :node | 
		| name affiliation firstname lastname id |
		name := self splitName: node nodes first nodes first asString.
		firstname := name first.
		lastname := name second.
		affiliation := affiliations
			               at:
			               node nodes second nodes first nodes first asString
			               ifAbsent: [ self halt ].
		id := ZoaAuthorID springer:
			      node nodes first nodes first asString hash.
		loader
			addTo: article
			authorFirstNamed: firstname
			lastName: lastname
			id: id
			affiliations: { affiliation } ]
]

{ #category : #'as yet unclassified' }
ZoaSpringerVisitor >> processDate: aXMLElement [

	self assert: aXMLElement nodes first nodes first isStringNode.
	article date: aXMLElement nodes first nodes first asString asDate
]

{ #category : #visiting }
ZoaSpringerVisitor >> processElement: anElement [

	(self isTitle: anElement) ifTrue: [ self processTitle: anElement ].
	(self isContributorArea: anElement) ifTrue: [ 
		self processContributorArea: anElement ].
	(self isAbstract: anElement) ifTrue: [ 
		self processAbstract: anElement ].
	(self isKeywordsArea: anElement) ifTrue: [ 
		self processKeywords: anElement ].
	(self isReference: anElement) ifTrue: [ 
		self processReference: anElement ].
	(self isDateReference: anElement) ifTrue: [ 
		self processDate: anElement ].

]

{ #category : #visiting }
ZoaSpringerVisitor >> processKeywords: anElement [
	| base keywords |
	base := anElement nodes select: [  : n | n name = 'span' and: [( n attributeAt: 'class' ifAbsent:'') includesSubstring: 'Keyword' ] ].
	self assert: base isNotEmpty .
	keywords := base  flatCollect: [ : n | n nodes select: [ : t | t isStringNode  ] thenCollect:[ : t | t asString]  ].
	loader setKeywords:  keywords into: article. 
]

{ #category : #visiting }
ZoaSpringerVisitor >> processReference: anElement [

	| text fromReference toReference source textStream authors title venue hasQuotedTitle |
	self assert: (anElement nodes first isStringNode or: [ 
			 anElement nodes first nodes first isStringNode ]).

	"Sometimes the title, venue and authors are wrapped.
	Extract the strings from the xml, ignoring the last Occurrences tag"
	self assert:
		(self element: anElement nodes last hasClass: 'Occurrences').
	text := String streamContents: [ :stream | 
		        anElement nodes allButLast do: [ :interestingNode | 
			        interestingNode isStringNode
				        ifTrue: [ stream nextPutAll: interestingNode string ]
				        ifFalse: [ 
					        interestingNode allElementsDo: [ :element | 
						        element stringNodesDo: [ :e | 
							        stream nextPutAll: e string ] ] ] ] ].

	"Parse the text. If reference comes from google scholar, it seems it has the form:
		author and author, title, venue"
	anElement nodes last allElements last nodes first ifNotNil: [ 
		source := anElement nodes last allElements last nodes first string.
		self assert: source = 'Google Scholar'.
		textStream := text readStream.
		hasQuotedTitle := (text indexOf: $”) > 0.
		hasQuotedTitle
			ifTrue: [ 
				authors := (((textStream upTo: $“) splitOn: 'and') flatCollect: [ 
					            :e | e substrings: ',' ])
					           collect: [ :e | e trimBoth ]
					           thenSelect: [ :e | e isNotEmpty ].
				title := (textStream upTo: $”) trimBoth.
				venue := textStream upToEnd trimBoth ]
			ifFalse: [ 
				authors := ((textStream upTo: $,) splitOn: 'and') collect: [ :e | 
					           e trimBoth ].
				title := (textStream upTo: $.) trimBoth.
				venue := textStream upToEnd trimBoth ] ].

	fromReference := ZoaArticleReference new
		                 reference: article doi;
		                 title: article title;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference:
			               (self detectHrefToArticle: anElement) urlDecoded;
		               title: title;
		               authors: authors;
		               venue: venue;
		               yourself.

	^ self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaSpringerVisitor >> processTitle: anElement [

	| node |
	self assert: (anElement nodes first isStringNode
		or: [ anElement nodes first name = 'span' ]).

	node := anElement nodes first isStringNode
		ifFalse: [ anElement nodes first ]
		ifTrue: [ anElement ].

	article title: node nodes first asString
]

{ #category : #visiting }
ZoaSpringerVisitor >> splitName: aString [
	| name |
	name := ' ' split: aString.
	^ name size = 1
		  ifTrue: [ (Character value: 160) asString split: aString ]
		  ifFalse: [ name ]
]
