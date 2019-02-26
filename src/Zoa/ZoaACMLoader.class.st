Class {
	#name : #ZoaACMLoader,
	#superclass : #ZoaLoader,
	#instVars : [
		'page'
	],
	#category : #Zoa
}

{ #category : #api }
ZoaACMLoader class >> loads: aString [
	^ aString = 'dl.acm.org'
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> idFor: anUrl [
	| id |
	id := anUrl query
		at: 'id'
		ifAbsent: [ ('.' split: (anUrl query at: 'doid')) first ].
	^ id
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadDocument: anUrl [
	| document |
	document := ZoaDocument new.
	document link: anUrl.
	self loadMetaFor: anUrl into: document.
	document abstract: (self privateAbstractFor: anUrl).
	self ensureDoiOn: document id: (self idFor: anUrl).
	^ document
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> loadMetaFor: anUrl into: document [
	| stream var content |
	stream := (ZnEasy get: anUrl) entity readStream.
	[ stream upToAll: '<meta name="'.
	stream atEnd ]
		whileFalse: [ var := stream upToAll: '" content="'.
			content := stream upToAll: '"'.
			self
				perform:
					('set{1}:into:'
						format:
							{(''
								join:
									(('_'
										split:
											((var copyReplaceAll: 'citation' with: '')
												copyReplaceAll: ':'
												with: '')) collect: #capitalized))}) asSymbol
				withArguments:
					{content.
					document} ]
]

{ #category : #'as yet unclassified' }
ZoaACMLoader >> privateAbstractFor: anUrl [
	| stream id |
	id := self idFor: anUrl.
	stream := (ZnEasy
		get: ('https://dl.acm.org/tab_abstract.cfm?id={1}' format: {id}))
		entity readStream.
	stream upToAll: '<p>'.
	^ stream upToAll: '</p>'
]

{ #category : #setting }
ZoaACMLoader >> setAbstractHtmlUrl: aString into: aZoaDocument [ 
	" Nothing to do "
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

{ #category : #setting }
ZoaACMLoader >> setLastpage: aString into: aZoaDocument [
	page
		ifNil: [ page := aString asNumber ]
		ifNotNil: [ aZoaDocument
				pages:
					{page.
					aString asNumber} ]
]

{ #category : #setting }
ZoaACMLoader >> setPdfUrl: aString into: aZoaDocument [
	^ aZoaDocument pdfUrl: aString asUrl
]
