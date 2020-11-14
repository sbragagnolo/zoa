"
Tag
"
Class {
	#name : #ZoaTag,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaTag >> = anOtherTag [

	^ self species = anOtherTag species and: [ name = anOtherTag name ]
]

{ #category : #accessing }
ZoaTag >> hash [
	^ name hash
]

{ #category : #accessing }
ZoaTag >> initialize [
	super initialize.
]

{ #category : #accessing }
ZoaTag >> name [
	^ name
]

{ #category : #accessing }
ZoaTag >> name: aName [
	name := aName
]

{ #category : #accessing }
ZoaTag >> printOn: aStream [
	aStream nextPutAll:'Tag('; nextPutAll: name; nextPutAll:')'.
]
