Class {
	#name : #ZoaArticleArticleReference,
	#superclass : #Object,
	#instVars : [
		'text',
		'reference',
		'from',
		'to'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaArticleArticleReference class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaReference' yourself
]

{ #category : #voyage }
ZoaArticleArticleReference class >> isVoyageRoot [
	^ true
]

{ #category : #accessing }
ZoaArticleArticleReference >> from: anArticle [
	from := anArticle
]

{ #category : #accessing }
ZoaArticleArticleReference >> reference: aString [
	reference := aString
]

{ #category : #accessing }
ZoaArticleArticleReference >> text: aString [ 
	text := aString
]

{ #category : #accessing }
ZoaArticleArticleReference >> to: anArticle [
	to := anArticle
]
