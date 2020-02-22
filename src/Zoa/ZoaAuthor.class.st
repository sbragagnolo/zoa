Class {
	#name : #ZoaAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'lastname'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaAuthor >> fullName [
	^ lastname, ', ', name
]

{ #category : #accessing }
ZoaAuthor >> lastname [
	^ lastname
]

{ #category : #accessing }
ZoaAuthor >> lastname: aName [
	lastname := aName
]

{ #category : #accessing }
ZoaAuthor >> name [
	^ name
]

{ #category : #accessing }
ZoaAuthor >> name: aName [
	name := aName.
]
