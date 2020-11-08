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

	| text fromReference toReference |
	self assert: anElement nodes first name = 'span'.

	text := ((self detectStringElement: anElement) asSortedCollection: [ 
		         :a 
		         :b | a size > b size ]) first.

	fromReference := ZoaArticleReference new
		                 reference: article doi;
		                 title: article title;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: (self detectHrefToArticle: anElement);
		               title: text;
		               yourself.


	self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAReference: anElement then: aBlock [
	^ (self isAReference: anElement) ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAnAuthor: anElement then: aBlock [

	^ (self element: anElement isType: 'li' andClass: 'loa__item') 
		  ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> isAReference: anElement [

	^ (self element: anElement isType: 'li' andClass: 'references__item') 
		  and: [ self element: anElement hasId: 'ref-' ]
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> isAbstract: anElement [

	^ self
		  element: anElement
		  isType: 'div'
		  andClasses: { 'article__section'. 'article__abstract' }
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
