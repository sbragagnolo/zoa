"
I do represent a visitor based loader. 
I load the related url to the article. I set some basic attribues and i delegate to a domain related visitor. I am abn abstract class. I require to learn how to get the doi from an url, and how to create a visitor
"
Class {
	#name : #ZoaVisitorLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaVisitorLoader class >> loads: aString [ 
	^ false
]

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
	html := (ZnClient new
		beOneShot;
		url: anUrl;
		maxNumberOfRedirects: 5; "Override the 3 by default"
		get;
		response) entity contents parseHTML.
	visitor := self createVisitor.
	visitor article: article.
	visitor loader: self.

	html acceptNodeVisitor: visitor.
	self loadUsingResearchGateReferencesTo: article.

	^ article
]

{ #category : #initialization }
ZoaVisitorLoader >> setCollectionNumber: aString into: aZoaArticle [ 
	aZoaArticle data at: #CollectionNumber put: aString
]

{ #category : #initialization }
ZoaVisitorLoader >> setContainerTitle: aString into: aZoaArticle [ 
	aZoaArticle containerTitle: aString
]
