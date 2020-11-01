"
I represent an authro reference. I link an article to an author, accounting the affiliations
"
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

{ #category : #adding }
ZoaArticleAuthorReference >> addAffiliation: aString [ 
	affiliation  add: aString 
]

{ #category : #accessing }
ZoaArticleAuthorReference >> affiliation [

	^ affiliation
]

{ #category : #accessing }
ZoaArticleAuthorReference >> affiliation: aString [
	aString ifNil: [ ^ self  ].
	affiliation := (aString isString
		                ifTrue: [ { aString } ]
		                ifFalse: [ aString ]) asSet
]

{ #category : #accessing }
ZoaArticleAuthorReference >> arrayKeywords [
	^ article arrayKeywords 
]

{ #category : #accessing }
ZoaArticleAuthorReference >> article [
	^ article
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
	affiliation printOn: aStream
]
