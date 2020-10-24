"
Author
"
Class {
	#name : #ZoaAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'lastname',
		'acmId',
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

{ #category : #accessing }
ZoaAuthor >> = anOtherArticle [

	^ self species = anOtherArticle species and: [ 
		  self uniqueId = anOtherArticle uniqueId ]
]

{ #category : #accessing }
ZoaAuthor >> acmId [
	^ ids at:#ACM ifAbsent: [  nil ]
]

{ #category : #accessing }
ZoaAuthor >> acmId: aString [ 
	ids at: #ACM put: aString 
]

{ #category : #add }
ZoaAuthor >> addArticle: aZoaArticleAuthorReference [
	^ self articles add: aZoaArticleAuthorReference
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
ZoaAuthor >> fullName [
	^ lastname, ', ', name
]

{ #category : #accessing }
ZoaAuthor >> hash [

	^ self uniqueId hash
]

{ #category : #accessing }
ZoaAuthor >> ids [

	^ ids ifNil: [ 
		  ids := Dictionary new.
		  acmId ifNotNil: [ self acmId: acmId ].
		  ids ]
]

{ #category : #accessing }
ZoaAuthor >> ieee [
	^ ids at:#IEEE ifAbsent: [  nil ]
]

{ #category : #accessing }
ZoaAuthor >> ieeeId: aString [ 
	ids at: #IEEE put: aString 
]

{ #category : #accessing }
ZoaAuthor >> initialize [ 
	super initialize. 
	articles := OrderedCollection new.
	ids := Dictionary new. 
]

{ #category : #accessing }
ZoaAuthor >> isLike: anOther [

	self ids keysAndValuesDo: [ :k :v | 
		((anOther ids includesKey: k) and: [ (anOther ids at: k) = v ]) 
			ifTrue: [ ^ true ] ].
	(lastname = anOther lastname and: [ name = anOther name ]) ifTrue: [ 
		^ true ].

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
	self assert: self acmId isNotNil.
	self assert: self acmId = anOtherAuthor acmId.
	self class allSlots
		do: [ :s | 
			| val |
			val := s read: anOtherAuthor.
			val ifNotNil: [ s write: val to: self ] ]
]

{ #category : #accessing }
ZoaAuthor >> name [
	^ name
]

{ #category : #accessing }
ZoaAuthor >> name: aName [
	name := aName.
]

{ #category : #accessing }
ZoaAuthor >> orcId [

	^ ids at: #ORCID ifAbsent: [ nil ]
]

{ #category : #accessing }
ZoaAuthor >> orcId: aString [ 
	ids at: #ORCID put: aString 
]

{ #category : #accessing }
ZoaAuthor >> printOn: aStream [
	aStream
		nextPutAll: lastname;
		nextPutAll: ', ';
		nextPutAll: name
]

{ #category : #'as yet unclassified' }
ZoaAuthor >> scienceDirectId: aString [

	ids at: #SCIENCEDIRECT put: aString
]

{ #category : #'as yet unclassified' }
ZoaAuthor >> springerId: anInteger [

	ids at: #SPRINGER put: anInteger asString
]

{ #category : #add }
ZoaAuthor >> uniqueId [

	^ '{1}:{2}:{3}' format: { 
			  acmId asString.
			  lastname asString.
			  name asString }
]
