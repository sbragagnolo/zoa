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
	^ VOContainer new collectionName: 'ZoaArticleArticleReference' yourself
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
ZoaArticleArticleReference >> printOn: aStream [
	aStream
		nextPutAll: 'REF:';
		nextPutAll: text
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
ZoaArticleArticleReference >> to [
	| zoa | 
	zoa := Zoa new. 
	^ to ifNil: [ 
		to := zoa loadAndSaveArticleDoi: reference.
		zoa saveArticle: from.
		to
	 ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> to: anArticle [
	to := anArticle
]
