Class {
	#name : #ZoaVisitorLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #'as yet unclassified' }
ZoaVisitorLoader >> createVisitor [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
ZoaVisitorLoader >> idFor: anUrl [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ZoaVisitorLoader >> loadDocument: anUrl [

	| article html visitor |
	article := ZoaArticle new.
	article publisher: self class publisher.
	article link: anUrl.
	article doi: (self idFor: anUrl).
	html := (ZnEasy get: anUrl) entity contents parseHTML.
	visitor := self createVisitor.
	visitor article: article.
	visitor loader: self.

	html acceptNodeVisitor: visitor.
	self loadUsingResearchGateReferencesTo: article.

	^ article
]
