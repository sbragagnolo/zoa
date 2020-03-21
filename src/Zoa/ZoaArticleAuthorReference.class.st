Class {
	#name : #ZoaArticleAuthorReference,
	#superclass : #Object,
	#instVars : [
		'author',
		'article',
		'affiliation'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaArticleAuthorReference class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaArticleAuthorReference' yourself
]

{ #category : #voyage }
ZoaArticleAuthorReference class >> isVoyageRoot [
	^ true
]

{ #category : #accessing }
ZoaArticleAuthorReference >> affiliation: aString [ 
	affiliation := aString
]

{ #category : #accessing }
ZoaArticleAuthorReference >> article: aZoaArticle [ 
	article := aZoaArticle
]

{ #category : #'as yet unclassified' }
ZoaArticleAuthorReference >> author [
	^ author
]

{ #category : #accessing }
ZoaArticleAuthorReference >> author: aZoaAuthor [ 
	author := aZoaAuthor
]

{ #category : #'as yet unclassified' }
ZoaArticleAuthorReference >> printOn: aStream [
	author printOn: aStream.
	aStream nextPutAll: affiliation
]
