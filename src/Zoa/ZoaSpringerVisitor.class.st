Class {
	#name : #ZoaSpringerVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'article',
		'loader'
	],
	#category : #'Zoa-Loader'
}

{ #category : #accessing }
ZoaSpringerVisitor >> article: aZoaArticle [ 
	article := aZoaArticle
]

{ #category : #'as yet unclassified' }
ZoaSpringerVisitor >> extractUrlFromHref: aString [

	| upToAll |
	upToAll := '&key='.
	(aString includesSubstring: 'doi.org/') ifTrue: [ 
		upToAll := 'doi.org/' ].
	(aString includesSubstring: '/doi/') ifTrue: [ upToAll := '/doi/' ].
	(aString includesSubstring: 'doi=')ifTrue: [ upToAll :=  'doi=' ].
	^ aString readStream
		  upToAll: upToAll;
		  upToEnd
]

{ #category : #testing }
ZoaSpringerVisitor >> hasDoi: aString [
	^ {'/servlet/linkout?' . '/doi/' . 'doi.org' . 'doi=' }
		anySatisfy: [ :a | aString includesSubstring: a ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> hrefsFor: anElement [
	| visitor |
	visitor := ZoaHrefExtractVisitor new.
	anElement acceptNodeVisitor: visitor.
	^ visitor hrefs
]

{ #category : #visiting }
ZoaSpringerVisitor >> isAbstract: anElement [

	^ anElement name = 'section' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: '') includesSubstring:
			  'Abstract' ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> isContributorArea: anElement [

	^ anElement name = 'div' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: '') includesSubstring:
			  'authors-affiliations u-interface' ]
]

{ #category : #testing }
ZoaSpringerVisitor >> isDateReference: aXMLElement [

	^ aXMLElement name = 'span' and: [ 
		  (aXMLElement attributeAt: 'class' ifAbsent: '') 
			  includesSubstring: 'article-dates__first-online' ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> isKeywordsArea: anElement [

	^ anElement name = 'div' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: '') includesSubstring:
			  'KeywordGroup' ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> isReference: anElement [

	^ anElement name = 'div' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: '') includesSubstring:
			  'CitationContent' ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> isTitle: anElement [
	^ (anElement name = 'h1') and: [( anElement attributeAt:'class' ifAbsent: '') includesSubstring: 'ChapterTitle' ]
]

{ #category : #testing }
ZoaSpringerVisitor >> isUrlToResearchEngine: aString [

	^ { 'http' } anySatisfy: [ :s | 
		  (aString indexOfSubCollection: s) > 0 ]
]

{ #category : #visiting }
ZoaSpringerVisitor >> loader: aLoader [

	loader := aLoader
]

{ #category : #visiting }
ZoaSpringerVisitor >> processAbstract: anElement [

	self assert: anElement nodes second nodes first isStringNode.
	article abstract:
		anElement nodes second nodes first asString
]

{ #category : #visiting }
ZoaSpringerVisitor >> processContributorArea: anElement [

	| authors affiliations articleRef |
	affiliations := Dictionary new.
	authors := OrderedCollection new.
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
		| author name affiliation |
		author := ZoaAuthor new.

		name := ' ' split: node nodes first nodes first asString.
		name size = 1 ifTrue: [ 
			name := (Character value: 160) asString split:
				        node nodes first nodes first asString ].
		author name: name first.
		author lastname: name second.
		affiliation := affiliations
			               at:
			               node nodes second nodes first nodes first asString
			               ifAbsent: [ self halt ].
		author springerId: node nodes first nodes first asString hash.


		(article authors noneSatisfy: [ :a | a isLike: author ]) ifTrue: [ 
			author := Zoa current findAuthorByExampleOrStore: author.
			articleRef := ZoaArticleAuthorReference new.
			articleRef affiliation: affiliation.
			articleRef author: author.
			author addArticle: articleRef.
			article addAuthorReference: articleRef ] ]
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
	| ref href |
	ref := ZoaArticleArticleReference new.

	self assert: anElement nodes first isStringNode .

	ref text: anElement nodes first  asString .
	
	href := (self hrefsFor: anElement) select:[ : s | s beginsWith: s .].
	
	ref reference: (
		href detect: [ :d | self hasDoi: d   ] ifFound:[ : h |  self extractUrlFromHref: h ]   ifNone:[
				href detect: [ :d | self isUrlToResearchEngine:  d   ] ifNone: [ self error: 'Unexpected case'  ]
		]).
	
	ref from: article. 
	article addReference: ref. 
	^ ref
]

{ #category : #visiting }
ZoaSpringerVisitor >> processTitle: anElement [

	self assert: anElement nodes first isStringNode.

	article title: anElement nodes first asString
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
