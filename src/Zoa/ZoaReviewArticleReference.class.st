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
	^ article keywords 
]

{ #category : #accessing }
ZoaReviewArticleReference >> title [
	^ article title
]