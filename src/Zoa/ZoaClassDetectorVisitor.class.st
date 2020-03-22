Class {
	#name : #ZoaClassDetectorVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'refs',
		'search'
	],
	#category : #'Zoa-Loader'
}

{ #category : #initialization }
ZoaClassDetectorVisitor >> initialize [ 
	super initialize .
	refs := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
ZoaClassDetectorVisitor >> refs [
	^ refs
]

{ #category : #initialization }
ZoaClassDetectorVisitor >> search: aSearch [
	search := aSearch
]

{ #category : #initialization }
ZoaClassDetectorVisitor >> visitElement: anElement [
	super visitElement: anElement.
	((anElement includesAttribute: 'class' ) and: [ (anElement attributeAt:'class') includesSubstring: search ]	) ifTrue: [ 
		refs add: anElement 
		
	 ]
]
