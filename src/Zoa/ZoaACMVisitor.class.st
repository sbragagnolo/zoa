"
Zoa visitor 
"
Class {
	#name : #ZoaACMVisitor,
	#superclass : #ZoaHTMLVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMVisitor >> addAuthor: anElement [

	| name lastname profile affiliation |
	name := ' ' split: (self detectStringElement:
			         (self detectNode: anElement class: 'loa__author-name')
				         first) first trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.


	affiliation := (self detectStringElement:
		                (self detectNode: anElement class: 'info__body')
			                first)
		               ifEmpty: [ 'not known affiliation' ]
		               ifNotEmpty: [ :a | a first ].
	profile := (self hrefsFor:
		            (self detectNode: anElement class: 'info__body') first)
		           ifEmpty: [ self error: 'iuhm, not profile?' ]
		           ifNotEmpty: [ :refs | 
			           refs detect: [ :r | 
				           { '/profile/'. '/author/' } anySatisfy: [ :valid | 
					           r beginsWith: valid ] ] ].
	profile := (profile copyReplaceAll: '/profile/' with: '')
		           copyReplaceAll: '/author/'
		           with: ''.
	^ loader
		  addTo: article
		  authorFirstNamed: name
		  lastName: lastname
		  id: (ZoaAuthorID acm: profile)
		  affiliations: { affiliation }
]

{ #category : #visiting }
ZoaACMVisitor >> createReferenceFromElement: anElement [

	| text reference |
	self assert: anElement nodes first name = 'span'.

	text := ((self detectStringElement: anElement) asSortedCollection: [ 
		         :a 
		         :b | a size > b size ]) first.

	reference := self detectHrefToArticle: anElement.
	self
		addReference: reference
		text: text
		from: article
		to: nil
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAReference: anElement then: aBlock [
	^ (self isAReference: anElement) ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAnAuthor: anElement then: aBlock [
	^( anElement name = 'li'
		and: [ (anElement attributeAt: 'class') = 'loa__item' ]) ifTrue: [ aBlock value ]
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

{ #category : #visiting }
ZoaACMVisitor >> processElement: anElement [

	self isAbstract: anElement then: [ self setAbstractUsing: anElement ].
	self ifIsAReference: anElement then: [ self createReferenceFromElement: anElement ].
	self ifIsAnAuthor: anElement then: [ self addAuthor: anElement ]
]

{ #category : #visiting }
ZoaACMVisitor >> setAbstractUsing: anElement [
	article abstract:  (' ' join: (self detectStringElement: anElement ) ).
	
]

{ #category : #visiting }
ZoaACMVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
