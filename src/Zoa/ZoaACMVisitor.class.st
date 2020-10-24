"
Zoa visitor 
"
Class {
	#name : #ZoaACMVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'document',
		'zoa'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMVisitor >> addAuthor: anElement [
	| author name lastname profile affiliation articleRef |
	
	name := ' ' split: (self detectStringElement: (self detectNode: anElement class: 'loa__author-name') first) first trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.
	
	
	affiliation := 	(self detectStringElement: (self detectNode: anElement class: 'info__body') first) ifEmpty: [ 'not known affiliation' ]  ifNotEmpty: [  : a | a first  ].
	profile := (self hrefsFor: (self detectNode: anElement class: 'info__body') first) ifEmpty: [  self error: 'iuhm, not profile?' ] 
	ifNotEmpty: [ : refs  | refs detect: [ : r | {'/profile/' . '/author/'  } anySatisfy: [ : valid | r beginsWith: valid ]]. ].
	profile := (profile copyReplaceAll: '/profile/' with: '') copyReplaceAll: '/author/' with: ''.
	author := ZoaAuthor new.
	author name: name.
	author lastname: lastname.
	author acmId: profile.
	(document authors noneSatisfy: [ :a | a isLike: author ])
		ifTrue: [  
			author := zoa findAuthorByExampleOrStore: author.
			articleRef := ZoaArticleAuthorReference new.
			articleRef affiliation: affiliation.
			articleRef author: author.
			author addArticle: articleRef.
			document addAuthorReference: articleRef ]
]

{ #category : #visiting }
ZoaACMVisitor >> addReference: anElement [
	self assert: anElement nodes first name = 'span'.
	
	document addReference: (self createReferenceFromElement: anElement)
]

{ #category : #accessing }
ZoaACMVisitor >> article: aZoaArticle [ 
	document := aZoaArticle
]

{ #category : #visiting }
ZoaACMVisitor >> createReferenceFromElement: anElement [
	| ref href |
	ref := ZoaArticleArticleReference new.
	ref text: 
	((self detectStringElement: anElement) asSortedCollection: [ : a : b | a size > b size ]  ) first. 

	href := (self hrefsFor: anElement) select:[ : s | s beginsWith: s .].
	
	ref reference: (
		href detect: [ :d | self hasDoi: d   ] ifFound:[ : h |  self extractUrlFromHref: h ]   ifNone:[
				href detect: [ :d | self isUrlToResearchEngine:  d   ] ifNone: [ self error: 'Unexpected case'  ]
		]).
	ref from: document. 
	^ ref
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> detectNode: aXMLElement class: aString [ 
	| vis | 
	vis := ZoaClassDetectorVisitor new.
	vis search: aString. 
	aXMLElement acceptNodeVisitor: vis.
	^ vis refs
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> detectStringElement: aNode [
	| vis |
	vis := ZoaStringDetectVisitor new.
	aNode acceptNodeVisitor:vis .
	^ vis strings collect: [ : s | s trimBoth] thenReject: [  : s | s isEmpty ]
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> extractUrlFromHref: aString [

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

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> hasDoi: aString [
	^ {'/servlet/linkout?' . '/doi/' . 'doi.org' . 'doi=' }
		anySatisfy: [ :a | aString includesSubstring: a ]
]

{ #category : #visiting }
ZoaACMVisitor >> hrefsFor: anElement [
	| visitor |
	visitor := ZoaHrefExtractVisitor new.
	anElement acceptNodeVisitor: visitor.
	^ visitor hrefs
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAReference: anElement then: aBlock [
	^ (self isAReference: anElement)
		ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAnAuthor: anElement then: aBlock [
	^( anElement name = 'li'
		and: [ (anElement attributeAt: 'class') = 'loa__item' ]) ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> initialize [
	super initialize.
	document := ZoaArticle new.
	zoa := Zoa new. 
]

{ #category : #visiting }
ZoaACMVisitor >> isAReference: anElement [
	^  anElement name = 'li'
		and: [ ((anElement attributeAt: 'class' ifAbsent: [ '' ])
				includesSubstring: 'references__item')
				and: [ (anElement attributeAt: 'id' ifAbsent: [ '' ]) beginsWith: 'ref-' ] ] 
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> isAbstract: anElement [
	^ anElement name = 'div'
		and: [ ((anElement attributeAt: 'class')
				includesSubstring: 'article__section')
				and: [ (anElement attributeAt: 'class')
						includesSubstring: 'article__abstract' ] ]
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> isAbstract: anElement then: aBlockClosure [
	^ (self isAbstract: anElement)
		ifTrue: [ aBlockClosure value ]
]

{ #category : #testing }
ZoaACMVisitor >> isUrlToResearchEngine: aString [

	^ { 'http' } anySatisfy: [ :s | 
		  (aString indexOfSubCollection: s) > 0 ]
]

{ #category : #visiting }
ZoaACMVisitor >> processElement: anElement [

	self isAbstract: anElement then: [ self setAbstractUsing: anElement ].
	self ifIsAReference: anElement then: [ self addReference: anElement ].
	self ifIsAnAuthor: anElement then: [ self addAuthor: anElement ]
]

{ #category : #visiting }
ZoaACMVisitor >> resolveAuthorReferenceFor: anElement [
	| author name lastname profile affiliation articleRef |
	name := ' '
		split:
			(anElement nodes first nodes first nodes detect: [ :e | e isElement ])
				nodes first nodes first nodes second string trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.
	affiliation := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'p' ] ]) nodes
		first string trimBoth.
	profile := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'a' ] ])  attributeAt: 'href'.
	self assert: (profile beginsWith: '/profile/').
	profile := profile copyReplaceAll: '/profile/' with: ''.
	author := ZoaAuthor new.
	author name: name.
	author lastname: lastname.
	author acmId: profile.
	author := zoa findAuthorByExampleOrStore: author.
	articleRef := ZoaArticleAuthorReference new.
	articleRef affiliation: affiliation.
	articleRef author: author.
	author addArticle: articleRef.
	^ articleRef
]

{ #category : #visiting }
ZoaACMVisitor >> setAbstractUsing: anElement [
	document abstract:  (' ' join: (self detectStringElement: anElement ) ).
	
]

{ #category : #visiting }
ZoaACMVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
