"
I represent a link from a review to an article. 
Through me we define if an article is to be included or not. If it is not to be included, i include a reason and a reason codification.
"
Class {
	#name : #ZoaReviewArticleReference,
	#superclass : #Object,
	#instVars : [
		'article',
		'included',
		'reason',
		'codification',
		'state',
		'responses'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaReviewArticleReference >> = anOtherRef [

	^ self species = anOtherRef species and: [ 
		  article = anOtherRef article ]
]

{ #category : #accessing }
ZoaReviewArticleReference >> article [
	^ article
]

{ #category : #accessing }
ZoaReviewArticleReference >> article: aZoaArticle [ 
	article := aZoaArticle
]

{ #category : #accessing }
ZoaReviewArticleReference >> authors [
	^ article authors 
]

{ #category : #accessing }
ZoaReviewArticleReference >> authorsReferences [
	^ article authorsReferences
]

{ #category : #accessing }
ZoaReviewArticleReference >> codification [
	^ codification
]

{ #category : #'as yet unclassified' }
ZoaReviewArticleReference >> codification: aSymbol [

	codification := aSymbol
]

{ #category : #accessing }
ZoaReviewArticleReference >> date [
	^ article date
]

{ #category : #accessing }
ZoaReviewArticleReference >> firstAuthor [
	^ article firstAuthor
]

{ #category : #accessing }
ZoaReviewArticleReference >> firstAuthorName [

	^ article firstAuthorName
]

{ #category : #accessing }
ZoaReviewArticleReference >> hash [

	^ article hash
]

{ #category : #accessing }
ZoaReviewArticleReference >> included: aFalse [ 
	included := aFalse
]

{ #category : #testing }
ZoaReviewArticleReference >> isIncluded [

	^ included ifNil: [ included := true ]
]

{ #category : #accessing }
ZoaReviewArticleReference >> keywords [
	^article keywords 
]

{ #category : #accessing }
ZoaReviewArticleReference >> printOn: aStream [

	aStream nextPutAll: 'Reference'.
	article title printOn: aStream
]

{ #category : #accessing }
ZoaReviewArticleReference >> reason [
	^ reason
]

{ #category : #accessing }
ZoaReviewArticleReference >> reason: aString [ 
	reason := aString
]

{ #category : #accessing }
ZoaReviewArticleReference >> responses [

	^ responses ifNil: [ responses := Dictionary new ]
]

{ #category : #accessing }
ZoaReviewArticleReference >> state [

	^ state ifNil: [ #'WhatPaper?' ]
]

{ #category : #accessing }
ZoaReviewArticleReference >> state: aState [ 
	^ state := aState . 
]

{ #category : #accessing }
ZoaReviewArticleReference >> title [
	^ article title
]
