"
Downloads from IEEE
"
Class {
	#name : #ZoaIEEELoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaIEEELoader class >> loads: aString [
	^ aString = 'ieeexplore.ieee.org'
]

{ #category : #api }
ZoaIEEELoader class >> publisher [
	^ #IEEE
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> loadDocument: anUrl [

	| document segments id entity |
	document := ZoaArticle new.
	document link: anUrl.
	segments := anUrl asUrl segments copy.
	document publisher:#IEEE.
	id := segments removeLast.
	[ id isAllDigits ] whileFalse: [ id := segments removeLast ].

	entity := ZnEasy get:
		          ('https://ieeexplore.ieee.org/document/{1}/references' 
			           format: { id }).

	self
		setJsonData:
		(self loadJsonFromIEEEStream: entity contents readStream)
		into: document.

	"Load references "
	^ document
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> loadJsonFromIEEEStream: stream [

	| finished contents json |
	stream upToAll: 'xplGlobal.document.metadata='.
	contents := ''.
	finished := false.
	[ finished ] whileFalse: [ 
		contents := contents , (stream upToAll: ';').
		[ contents last = $} or: [ stream atEnd ] ] whileFalse: [ 
			contents := contents , (stream upToAll: ';') ].
		[ 
		json := STONJSON fromString: contents.
		finished := true ]
			on: STONReaderError
			do: [ :e | stream atEnd ifTrue: [ self error: 'cannot parse :( ' ] ] ].
	^ json
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> setAuthors: anArray into: anArticle [

	| lastname firstname userId affiliations |
	anArray do: [ :authorEntry | 
		| affiliation |
		firstname := (authorEntry at: 'firstName' ifAbsent: '') ifEmpty: [ 
			             authorEntry at: 'name' ].
		lastname := (authorEntry at: 'lastName') ifEmpty: [ 
			            authorEntry at: 'name' ].
		userId := authorEntry
			          at: #id
			          ifPresent: [ :id | ZoaAuthorID ieee: id ]
			          ifAbsent: [ ZoaAuthorID unknown: firstname , lastname ].
		affiliation := authorEntry at: #affiliation ifAbsent: [ {  } ].

		self
			addTo: anArticle
			authorFirstNamed: firstname
			lastName: lastname
			id: userId
			affiliations: affiliations ]
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> setDateOfInsertion: aString into: anArticle [
	anArticle date: aString asDate
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> setKeywords: anArray into: anArticle [

	| keywords |
	keywords := (anArray flatCollect: [ :a | a at: #kwd ]) asSet
		            asOrderedCollection.

	super setKeywords: keywords into: anArticle
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> setPdfUrlIfNeeded: document with: id [
	document pdfUrl
		ifNil: [ document
				pdfUrl:
					('https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber={1}'
						format: {id}) ]
]
