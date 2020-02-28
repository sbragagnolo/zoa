"
Author
"
Class {
	#name : #ZoaAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'lastname'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaAuthor class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaAuthor' yourself
]

{ #category : #voyage }
ZoaAuthor class >> isVoyageRoot [
	^ true
]

{ #category : #accessing }
ZoaAuthor >> citeName [
	^ self fullName readStream next: 10
]

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
