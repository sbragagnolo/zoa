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
	^ ('https://dl.acm.org/action/exportCiteProcCitation?dois={1}&targetFile=custom-bibtex&format=bibTex'
		format: {aDoi urlEncoded}) asZnUrl
]

{ #category : #api }
ZoaACMLoader class >> loads: aString [
	^ aString = 'dl.acm.org'
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> idFor: anUrl [
	| id |
	id := anUrl query at: 'id' ifAbsent: [ anUrl query at: 'dois' ].
	^ id
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadDocument: anUrl [
	| document |
	document := ZoaDocument new.
	document link: anUrl.
	document doi: (self idFor: anUrl).
	self loadMetaFor: anUrl into: document.
	document abstract: (self privateAbstractFor: anUrl).
	^ document
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadMetaFor: anUrl into: document [
	| metadata |
	metadata := STONJSON
		fromStream: (ZnEasy get: anUrl) entity readStream.
	metadata := (metadata at: #items) first at: document doi.
	metadata
		keysAndValuesDo: [ :key :value | 
			self
				perform: ('set{1}:into:' format: {(self sanitizeSymbol: key)}) asSymbol
				withArguments:
					{value.
					document} ]
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
