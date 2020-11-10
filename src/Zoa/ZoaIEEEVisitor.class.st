"
I am a visitor on IEEE. But i am different from the other visitors. I am to be used with the firefox crawling plugin. 
"
Class {
	#name : #ZoaIEEEVisitor,
	#superclass : #ZoaHTMLVisitor,
	#instVars : [
		'loading'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaIEEEVisitor >> itDefinesCitationSection: anElement [

	^ anElement name = 'citations'
		
]

{ #category : #visiting }
ZoaIEEEVisitor >> itDefinesReferenceSection: anElement [

	^ anElement name = 'references'
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadCitation: element [

	| text reference fromReference toReference |
	self assert:
		element nodes first nodes first nodes second name = 'span'.
	text := (self detectStringElement:
		         element nodes first nodes first nodes second) first.

	reference := self detectHrefToArticle: element.
	reference ifNil: [ ^ self ].



	fromReference := ZoaArticleReference new
		                 reference: reference;
		                 title: text;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: article doi;
		               title: article title;
		               yourself.


	self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaIEEEVisitor >> loadElement: anElement [

	loading = #references ifTrue: [ self loadReference: anElement ].
	loading = #citations ifTrue: [ self loadCitation: anElement ]
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadReference: element [

	| text reference fromReference toReference |
	self assert:
		element nodes first nodes first nodes first nodes second name
		= 'span'.
	text := (self detectStringElement:
		         element nodes first nodes first nodes first nodes second)
		        first.
	reference := self detectHrefToArticle: element.
	reference ifNil: [ ^ self ].

	fromReference := ZoaArticleReference new
		                 reference: article doi;
		                 title: article title;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: reference;
		               title: text;
		               yourself.


	^ self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaIEEEVisitor >> processElement: anElement [
	(self itDefinesReferenceSection: anElement ) ifTrue: [  self setLoadingModeToReference ].
	(self itDefinesCitationSection: anElement ) ifTrue: [  self setLoadingModeToCites ].
	(self element: anElement hasClass: 'reference-container') ifTrue: [ self loadElement: anElement ].
	
	
]

{ #category : #visiting }
ZoaIEEEVisitor >> setLoadingModeToCites [

	loading := #citations
]

{ #category : #visiting }
ZoaIEEEVisitor >> setLoadingModeToReference [
	 loading := #references
	
]

{ #category : #visiting }
ZoaIEEEVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
