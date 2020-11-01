"
Tag
"
Class {
	#name : #ZoaTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'articles'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaTag class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaTag' yourself
]

{ #category : #voyage }
ZoaTag class >> isVoyageRoot [
	^ true
]

{ #category : #accessing }
ZoaTag >> addArticle: anArticle [
	articles add: anArticle .
	
]

{ #category : #accessing }
ZoaTag >> articles [
	^ articles
]

{ #category : #accessing }
ZoaTag >> articles: acollectionOfArticles [
	articles := acollectionOfArticles asSet
]

{ #category : #accessing }
ZoaTag >> initialize [
	super initialize.
	articles := Set new
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

{ #category : #removing }
ZoaTag >> removeArticle: aZoaArticle [

	articles remove: aZoaArticle
]
