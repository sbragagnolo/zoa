Class {
	#name : #ZoaSpringerLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaSpringerLoader class >> loads: aString [

	^ aString includesSubstring: 'springer'
]

{ #category : #'as yet unclassified' }
ZoaSpringerLoader >> idFor: aZnUrl [

	self assert: aZnUrl segments size = 2.
	^ '/' join: aZnUrl segments
]

{ #category : #'as yet unclassified' }
ZoaSpringerLoader >> loadDocument: anUrl [

	| article html visitor |
	article := ZoaArticle new.
	article link: anUrl.
	article doi: (self idFor: anUrl).
	article publisher: #SPRINGER. 
	html := (ZnEasy get: anUrl) entity contents parseHTML.
	visitor := ZoaSpringerVisitor new.
	visitor article: article.
	visitor loader: self.
	html acceptNodeVisitor: visitor.
	self loadUsingResearchGateReferencesTo: article.
	^ article
]
