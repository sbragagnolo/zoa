Class {
	#name : #ZoaWileyLoader,
	#superclass : #ZoaVisitorLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaWileyLoader class >> formatUrl: aZnUrl forDoi: aDoi [
self halt. 
	^ ('https://dl.acm.org/doi/{1}' format: {aDoi}) asUrl
]

{ #category : #api }
ZoaWileyLoader class >> loads: aString [

	^ aString = 'onlinelibrary.wiley.com'
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> createVisitor [ 
	^ ZoaWileyVisitor new 
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> idFor: aZnUrl [

	self assert: aZnUrl segments first = #doi.
	^ '/' join: (aZnUrl segments last: 2)
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> loadDocument: aDocument [

	| article references visitor |
	article := super loadDocument: aDocument.
	references := (ZnEasy get: (self referencesUrl: article doi)) entity
		              contents.
	(references includesSubstring:
		 '<div class=NoContentMessage>This article does not include References</div>') 
		ifTrue: [ ^ article ].
	visitor := self createVisitor.
	visitor loader: self.
	visitor article: article.
	references parseHTML acceptNodeVisitor: visitor.
	^ article
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> referencesUrl: aDoi [

	^ ('https://onlinelibrary.wiley.com/action/ajaxShowEnhancedAbstract?ajax=true&doi='
	   , aDoi) asZnUrl
]
