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

	| text reference |
	self assert:
		element nodes first nodes first nodes first nodes second name
		= 'span'.
	text := (self detectStringElement:
		         element nodes first nodes first nodes second) first.

	reference := self detectHrefToArticle: element.
	reference ifNil: [ ^ self ].
	^ self
		  addReference: reference
		  text: text
		  from: nil
		  to: article
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadReference: element [

	| text reference |
	self assert:
		element nodes first nodes first nodes first nodes second name
		= 'span'.
	text := (self detectStringElement:
		         element nodes first nodes first nodes first nodes second)
		        first.
	reference := self detectHrefToArticle: element.
	reference ifNil: [ ^ self ].
	^ self
		  addReference: reference
		  text: text
		  from: article
		  to: nil
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
