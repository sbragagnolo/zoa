"
Downloads from ACM
"
Class {
	#name : #ZoaACMLoader,
	#superclass : #ZoaLoader,
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

{ #category : #'as yet unclassified' }
ZoaACMLoader >> idFor: anUrl [
	| id |
	id := '/' join: (anUrl segments last: 2).
	^ id
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadDocument: anUrl [
	| article html visitor |
	article := ZoaArticle new.
	article link: anUrl.
	article doi: (self idFor: anUrl). 
	html := (ZnEasy get: anUrl) entity contents parseHTML .
	visitor := ZoaACMVisitor new .
	visitor article: article. 
	html acceptNodeVisitor: visitor.
	
	self loadMetaFor: anUrl into: article.
	
	^ article
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadMetaFor: anUrl into: document [
	| metadata exportUrl |
	exportUrl:=  ('https://dl.acm.org/action/exportCiteProcCitation?dois={1}&targetFile=custom-bibtex&format=bibTex'
		format: {self idFor: anUrl}) asZnUrl.
	
	metadata := STONJSON
		fromStream: (ZnEasy get: exportUrl) entity readStream.
	metadata := (metadata at: #items) first at: document doi.
	metadata 	keysAndValuesDo: [ :key :value | 
		self perform: ('set{1}:into:' format: {(self sanitizeSymbol: key)}) asSymbol
				withArguments: {value . document} ]
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> privateAbstractFor: anUrl [
	| stream id |

	id := self idFor: anUrl.
	stream := (ZnEasy
		get: ('https://dl.acm.org/doi/{1}' format: {id}))
		entity readStream.
	stream upToAll: 'article__section article__abstract hlFld-Abstract'.
	stream upToAll: '<p>'.
	^ stream upToAll: '</p>'
]

{ #category : #setting }
ZoaACMLoader >> setAuthor: anArray into: aZoaDocument [
	super
		setAuthor: (anArray collect: [ :d | ' ' join: d values ])
		into: aZoaDocument
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setCollectionTitle: aString into: aZoaDocument [
	self setConference: aString into: aZoaDocument
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setContainerTitle: aString into: aZoaDocument [
	self setTitle: aString into: aZoaDocument
]

{ #category : #setting }
ZoaACMLoader >> setFirstpage: aString into: aZoaDocument [ 
	page
		ifNil: [ page := aString asNumber ]
		ifNotNil: [ aZoaDocument
				pages:
					{page.
					aString asNumber} ]
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setKeyword: aString into: aZoaDocument [
	self setKeywords: aString into: aZoaDocument
]

{ #category : #setting }
ZoaACMLoader >> setLastpage: aString into: aZoaDocument [
	page
		ifNil: [ page := aString asNumber ]
		ifNotNil: [ aZoaDocument
				pages:
					{page.
					aString asNumber} ]
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> setNumber: aString into: aZoaDocument [
	aZoaDocument number: aString
]

{ #category : #setting }
ZoaACMLoader >> setPdfUrl: aString into: aZoaDocument [
	^ aZoaDocument pdfUrl: aString asUrl
]
