"
Author
"
Class {
	#name : #ZoaAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'lastname',
		'articles',
		'ids'
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

{ #category : #add }
ZoaAuthor >> = otherAuthor [
	^ self species = otherAuthor species and:[ self ids = otherAuthor ids] 
]

{ #category : #add }
ZoaAuthor >> addArticle: aZoaArticleAuthorReference [
	^ self articles add: aZoaArticleAuthorReference
]

{ #category : #'as yet unclassified' }
ZoaAuthor >> addId: anId [
	ids add: anId 
]

{ #category : #'as yet unclassified' }
ZoaAuthor >> articles [
	^ articles ifNil: [ articles := OrderedCollection new  ].
]

{ #category : #accessing }
ZoaAuthor >> citeName [
	^( self lastname readStream next: 10) 
]

{ #category : #accessing }
ZoaAuthor >> firstname [
	^ name
]

{ #category : #accessing }
ZoaAuthor >> fullName [
	^ lastname, ', ', name
]

{ #category : #add }
ZoaAuthor >> hash [
	^ self ids hash
]

{ #category : #accessing }
ZoaAuthor >> ids [

	^ ids 
]

{ #category : #accessing }
ZoaAuthor >> initialize [ 
	super initialize. 
	articles := OrderedCollection new.
	ids := Set new.
]

{ #category : #accessing }
ZoaAuthor >> isLike: anOther [

	((self ids includesAny: anOther ids) or: [ 
		 lastname = anOther lastname and: [ name = anOther name ] ]) 
		ifTrue: [ ^ true ].

	"Should add orcid "
	^ false
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
ZoaAuthor >> mergeWith: anOtherAuthor [
	| merged |
	self = anOtherAuthor ifTrue: [ ^ self ].
	
	
	self halt.
self error: 'Ensure that the left and right author have the same id'.
	self class allSlots
		do: [ :s | 
			| val |
			val := s read: anOtherAuthor.
			val ifNotNil: [ s write: val to: self ] ]
]

{ #category : #accessing }
ZoaAuthor >> name [

	^ self fullName , ' ('
	  , (' ' join: (ids collect: [ :i | i asString ])) , ')'
]

{ #category : #accessing }
ZoaAuthor >> name: aName [
	name := aName.
]

{ #category : #accessing }
ZoaAuthor >> printOn: aStream [
	aStream
		nextPutAll: lastname;
		nextPutAll: ', ';
		nextPutAll: name
]

{ #category : #'as yet unclassified' }
ZoaAuthor >> threeWayCompareTo: aZoaAuthor [
	aZoaAuthor isString ifTrue:[^1].
	^ self fullName threeWayCompareTo: aZoaAuthor fullName
]
