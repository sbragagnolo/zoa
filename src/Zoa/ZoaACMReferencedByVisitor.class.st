"
I do represent a visitor of ACM in the context of harvesting citations instead of references .
"
Class {
	#name : #ZoaACMReferencedByVisitor,
	#superclass : #ZoaACMVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMReferencedByVisitor >> createReferenceToElement: anElement [

	| text texts fromReference toReference |
	self assert: anElement nodes first name = 'span'.

	texts := (self detectStringElement: anElement) asSortedCollection: [ 
		         :a 
		         :b | a size > b size ].
	texts ifEmpty: [ ^ nil ].
	text := texts first.

	fromReference := ZoaArticleReference new
		                 reference: (self detectHrefToArticle: anElement);
		                 title: text;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: article doi;
		               title: article title;
		               yourself.


	self  addReferenceFrom: fromReference to: toReference
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
