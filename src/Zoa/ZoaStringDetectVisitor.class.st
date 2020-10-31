Class {
	#name : #ZoaStringDetectVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'strings'
	],
	#category : #'Zoa-HTMLAnalysis'
}

{ #category : #initialization }
ZoaStringDetectVisitor >> initialize [ 
	super initialize .
	strings := OrderedCollection new.
]

{ #category : #initialization }
ZoaStringDetectVisitor >> strings [
	^ strings
]

{ #category : #initialization }
ZoaStringDetectVisitor >> visitStringNode: aStringNode [
	strings add: aStringNode string.
]
