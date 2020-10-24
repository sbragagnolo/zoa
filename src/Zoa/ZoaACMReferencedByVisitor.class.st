Class {
	#name : #ZoaACMReferencedByVisitor,
	#superclass : #ZoaACMVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMReferencedByVisitor >> addReference: anElement [

	self assert: anElement nodes first name = 'span'.

	document addReference: (self createReferenceToElement:  anElement)
]

{ #category : #visiting }
ZoaACMReferencedByVisitor >> createReferenceToElement: anElement [
	| ref href |
	ref := ZoaArticleArticleReference new.
	ref text: 
	((self detectStringElement: anElement) asSortedCollection: [ : a : b | a size > b size ]  ) first. 

	href := (self hrefsFor: anElement) select:[ : s | s beginsWith: s .].
	
	ref reference: (
		href detect: [ :d | self hasDoi: d   ] ifFound:[ : h |  self extractUrlFromHref: h ]   ifNone:[
				href detect: [ :d | self isUrlToResearchEngine: d   ] ifNone: [ self error: 'Unexpected case'  ]
		]).
	ref to: document.
	^ ref
]

{ #category : #visiting }
ZoaACMReferencedByVisitor >> isAReference: anElement [
	^ anElement name = 'li' and: [ 
		  (anElement attributeAt: 'class' ifAbsent: [ '' ]) 
			  includesSubstring: 'references__item' ]
]

{ #category : #visiting }
ZoaACMReferencedByVisitor >> processElement:  anElement [
	self ifIsAReference: anElement then: [  self addReference: anElement ].
]
