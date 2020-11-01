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

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadCitation: element [

	| text reference fromReference toReference |
	self assert:
		element nodes first nodes first nodes first nodes second name
		= 'span'.
	text := (self detectStringElement:
		         element nodes first nodes first nodes second) first.

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


	self addReferenceFrom: fromReference to: toReference
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

	anElement name = 'references' ifTrue: [ loading := #references ].
	anElement name = 'citations' ifTrue: [ loading := #citations ].
	((anElement attributeAt: 'class' ifAbsent:'') includesSubstring: 'reference-container') ifTrue: [ 
			loading = #references  ifTrue: [ self loadReference: anElement ].
			loading = #citations  ifTrue: [ self loadCitation: anElement ].
	 ] 
]

{ #category : #visiting }
ZoaIEEEVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
