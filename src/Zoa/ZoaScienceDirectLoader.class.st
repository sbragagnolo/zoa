Class {
	#name : #ZoaScienceDirectLoader,
	#superclass : #ZoaLoader,
	#category : #Zoa
}

{ #category : #api }
ZoaScienceDirectLoader class >> loads: aString [
	^ aString = 'sciencedirect.com'
]

{ #category : #'as yet unclassified' }
ZoaScienceDirectLoader >> loadDocument: anUrl [ 
| document bibtex segments id |
	document := ZoaDocument new.
	document link: anUrl.
	segments := anUrl asUrl segments copy.
	id := segments removeLast.
	[ id allButFirst  isAllDigits ] whileFalse: [ id := segments removeLast ].
	bibtex := (ZnEasy
		get:
			('https://www.sciencedirect.com/sdfe/arp/cite?pii={1}&format=text/x-bibtex'
				format: {id})) entity.
	self loadBibtex: bibtex into: document.
	self setPdfUrlIfNeeded: document with: id. 
	
	^ document
"	"
]

{ #category : #'as yet unclassified' }
ZoaScienceDirectLoader >> setPdfUrlIfNeeded: document with: id [
	document pdfUrl
		ifNil: [ document
				pdfUrl:
					('https://www.sciencedirect.com/science/article/pii/{1}/pdf'
						format: {id}) ]
]
