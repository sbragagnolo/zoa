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

	| anArray articleRef author |
	anArray := ' and ' split: aString.
self halt.
	anArray do: [ :authorEntry | 
		|  name |
		name := ' ' split: authorEntry.
		author := ZoaAuthor new.
		author name: name first.

		author lastname: name second.

		author scienceDirectId:
			'UNKNOWN TS' , author fullName hash asString,  DateAndTime now asUnixTime asString.
self halt .
		(aZoaArticle authors noneSatisfy: [ :a | a isLike: author ]) 
			ifTrue: [ 
				author := Zoa current findAuthorByExampleOrStore: author.
				articleRef := ZoaArticleAuthorReference new.
				articleRef affiliation: {  }.
				articleRef author: author.
				author addArticle: articleRef.
				aZoaArticle addAuthorReference: articleRef ] ]
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
