Class {
	#name : #ZoaArxivVisitor,
	#superclass : #ZoaWileyVisitor,
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaArxivVisitor >> isAbstract: anElement [

	^ (self isMetaElement: anElement) and: [ 
		  self
			  attribute: 'property'
			  inElement: anElement
			  beginsWith: 'og:description' ]
]
