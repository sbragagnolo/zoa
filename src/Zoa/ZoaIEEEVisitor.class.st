Class {
	#name : #ZoaIEEEVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'article',
		'references'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaIEEEVisitor >> article: anArtile [

	article := anArtile
]

{ #category : #visiting }
ZoaIEEEVisitor >> processElement: anElement [
 	
]

{ #category : #visiting }
ZoaIEEEVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
