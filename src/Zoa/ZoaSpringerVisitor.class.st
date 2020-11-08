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

	self assert: anElement nodes second nodes first isStringNode.
	article abstract:
		anElement nodes second nodes first asString
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
ZoaSpringerVisitor >> processKeywords: anElement [
	| base keywords |
	base := anElement nodes select: [  : n | n name = 'span' and: [( n attributeAt: 'class' ifAbsent:'') includesSubstring: 'Keyword' ] ].
	self assert: base isNotEmpty .
	keywords := base  flatCollect: [ : n | n nodes select: [ : t | t isStringNode  ] thenCollect:[ : t | t asString]  ].
	loader setKeywords:  keywords into: article. 
]

{ #category : #visiting }
ZoaSpringerVisitor >> processReference: anElement [

	| reference text fromReference toReference |
	self assert: anElement nodes first isStringNode.

	text := anElement nodes first asString.


	fromReference := ZoaArticleReference new
		                 reference: article doi;
		                 title: article title;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: (self detectHrefToArticle: anElement);
		               title: text;
		               yourself.


	^ self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaSpringerVisitor >> processTitle: anElement [

	self assert: anElement nodes first isStringNode.

	article title: anElement nodes first asString
]

{ #category : #visiting }
ZoaSpringerVisitor >> splitName: aString [
	| name |
	name := ' ' split: aString.
	^ name size = 1
		  ifTrue: [ (Character value: 160) asString split: aString ]
		  ifFalse: [ name ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> visitElement: anElement [

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

	super visitElement: anElement
]
