Class {
	#name : #ZoaACMReferencedByVisitor,
	#superclass : #ZoaACMVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMReferencedByVisitor >> createReferenceToElement: anElement [

	| text reference texts |
	self assert: anElement nodes first name = 'span'.

	texts := (self detectStringElement: anElement) asSortedCollection: [ 
		         :a 
		         :b | a size > b size ].
	texts ifEmpty: [ ^ nil ].
	text := texts first.
	

	reference := self detectHrefToArticle: anElement. 
	self
		addReference: reference
		text: text
		from: nil
		to: article
]

{ #category : #visiting }
ZoaACMReferencedByVisitor >> isAReference: anElement [
	^ anElement name = 'li' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: [ '' ]) 
			  includesSubstring: 'references__item' ]
]

{ #category : #visiting }
ZoaACMReferencedByVisitor >> processElement:  anElement [
	self ifIsAReference: anElement then: [  self createReferenceToElement: anElement ].
]
