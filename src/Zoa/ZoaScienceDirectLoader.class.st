"
Downloads from Science direct
"
Class {
	#name : #ZoaScienceDirectLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaScienceDirectLoader class >> loads: aString [
	^ (aString indexOfSubCollection: 'sciencedirect.com') > 0
]

{ #category : #api }
ZoaScienceDirectLoader class >> publisher [
	^ #ScienceDirect
]

{ #category : #'as yet unclassified' }
ZoaScienceDirectLoader >> loadDocument: anUrl [

	| document bibtex segments id |
	document := ZoaArticle new.
	document link: anUrl.
	segments := anUrl asUrl segments copy.
	id := segments removeLast.
	document publisher: #SCIENCEDIRECT. 
	[ (id allButFirst copyReplaceAll:'X'with: '') isAllDigits ] whileFalse: [ 
		id := segments removeLast ].
	bibtex := (ZnEasy get:
		           ('https://www.sciencedirect.com/sdfe/arp/cite?pii={1}&format=text/x-bibtex&withabstract=true' 
			            format: { id })) entity.
	self loadBibtex: bibtex into: document.
	self setPdfUrlIfNeeded: document with: id.
	self ensureDoiOn: document id: id.
	self loadUsingResearchGateReferencesTo: document.
	^ document
]

{ #category : #initialization }
ZoaScienceDirectLoader >> setAuthor: aString into: aZoaArticle [

	| lastname firstname userId array |
	array := ' and ' split: aString.
	array do: [ :authorEntry | 
		| name |
		name := ' ' split: authorEntry.

		firstname := name first.

		lastname := name second.

		userId := ZoaAuthorID unknown: firstname , lastname.
		self
			addTo: aZoaArticle
			authorFirstNamed: firstname
			lastName: lastname
			id: userId
			affiliations: {  } ]
]

{ #category : #initialization }
ZoaScienceDirectLoader >> setKeywords: aString into: anArticle [ 
	super setKeywords:( ',' split: aString ) into: anArticle
]

{ #category : #'as yet unclassified' }
ZoaScienceDirectLoader >> setPdfUrlIfNeeded: document with: id [
	document pdfUrl
		ifNil: [ document
				pdfUrl:
					('https://www.sciencedirect.com/science/article/pii/{1}/pdf'
						format: {id}) ]
]
