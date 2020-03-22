Class {
	#name : #ZoaHrefExtractVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'hrefs'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaHrefExtractVisitor >> hrefs [
	^ hrefs
]

{ #category : #visiting }
ZoaHrefExtractVisitor >> initialize [ 
	super initialize .
	hrefs := OrderedCollection new.
]

{ #category : #visiting }
ZoaHrefExtractVisitor >> visitElement: anElement [
	super visitElement: anElement.
	anElement name = #a ifTrue: [ 
		hrefs add: (anElement attributeAt: #href) 
	].
	anElement name = 'pub-id' ifTrue:	[ 
		hrefs add: '/doi/' , (anElement attributeAt: 'xlink:href') 
	].
]
