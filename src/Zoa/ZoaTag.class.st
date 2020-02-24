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

{ #category : #accessing }
ZoaTag >> addArticle: anArticle [
	articles add: anArticle .
	
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
