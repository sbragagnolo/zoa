Class {
	#name : #ZoaReviewArticleReference,
	#superclass : #Object,
	#instVars : [
		'article',
		'included',
		'reason',
		'codification'
	],
	#category : #'Zoa-Model'
}

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
ZoaReviewArticleReference >> firstAuthorName [

	^ article firstAuthorName
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
ZoaReviewArticleReference >> reason [
	^ reason
]

{ #category : #accessing }
ZoaReviewArticleReference >> reason: aString [ 
	reason := aString
]

{ #category : #accessing }
ZoaReviewArticleReference >> tags [
	^ article tags
]

{ #category : #accessing }
ZoaReviewArticleReference >> title [
	^ article title
]
