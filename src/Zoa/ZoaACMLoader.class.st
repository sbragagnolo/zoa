"
Downloads from ACM
"
Class {
	#name : #ZoaACMLoader,
	#superclass : #ZoaVisitorLoader,
	#instVars : [
		'page'
	],
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaACMLoader class >> formatUrl: aZnUrl forDoi: aDoi [
	^ ('https://dl.acm.org/doi/{1}' format: {aDoi}) asUrl
]

{ #category : #api }
ZoaACMLoader class >> loads: aString [
	^ aString = 'dl.acm.org' or: [ aString = 'portal.acm.org' ]
]

{ #category : #api }
ZoaACMLoader class >> publisher [
	^ #ACM
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> createVisitor [
	^ ZoaACMVisitor new 
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> idFor: anUrl [
	| id |
	id := '/' join: (anUrl segments last: 2).
	^ id
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadDocument: anUrl [

	| article |
	article := super loadDocument: anUrl.
	self loadReferencedBy: anUrl into: article.
	self loadMetaFor: anUrl into: article.


	^ article
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadMetaFor: anUrl into: document [

	| metadata exportUrl entity |
	exportUrl := ('https://dl.acm.org/action/exportCiteProcCitation?dois={1}&targetFile=custom-bibtex&format=bibTex' 
		              format: { (self idFor: anUrl) }) asZnUrl.
	entity := (ZnEasy get: exportUrl) entity.
	entity ifNotNil: [ 
		metadata := STONJSON fromStream: entity readStream.
		metadata := (metadata at: #items) first at: document doi.
		metadata keysAndValuesDo: [ :key :value | 
			self
				perform:
				('set{1}:into:' format: { (self sanitizeSymbol: key) }) asSymbol
				withArguments: { 
						value.
						document } ] ]
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadReferencedBy: anUrl into: article [

	| exportUrl html visitor |
	exportUrl := ('https://dl.acm.org/action/ajaxShowCitedBy?ajax=true&doi={1}' 
		              format: { (self idFor: anUrl) }) asZnUrl.
	html := (ZnEasy get: exportUrl) entity contents parseHTML .

	visitor := ZoaACMReferencedByVisitor new .
	visitor article: article. 
	
	html acceptNodeVisitor: visitor.

]

{ #category : #initialization }
ZoaACMLoader >> setAuthor: aCollection into: aZoaArticle [ 
	" Author is managed by the HTML visitor "
]

{ #category : #initialization }
ZoaACMLoader >> setCollectionTitle: aString into: aZoaArticle [

	aZoaArticle data at: #CollectionTitle put: aString
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setKeyword: aString into: aZoaDocument [
	self setKeywords: aString into: aZoaDocument
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setKeywords: aString into: anArticle [
	| keys | 
	keys := (([ :c | c = $; or: [ c = $, ] ] split: aString) collect: #trimBoth).
	super setKeywords: keys into: anArticle
]
