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

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> loadDocument: anUrl [
	| document bibtex segments id |
	document := ZoaArticle new.
	self halt. 
	document link: anUrl.
	segments := anUrl asUrl segments copy.
	id := segments removeLast.
	[ id isAllDigits ] whileFalse: [ id := segments removeLast ].
	bibtex := (ZnEasy
		get:
			('https://ieeexplore.ieee.org/xpl/downloadCitations?recordIds={1}&download-format=download-bibtex&citations-format=citation-abstract'
				format: {id})) entity.
	self loadBibtex: bibtex into: document.
	self setPdfUrlIfNeeded: document with: id.
	self ensureDoiOn: document id: id.
	^ document
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> setPdfUrlIfNeeded: document with: id [
	document pdfUrl
		ifNil: [ document
				pdfUrl:
					('https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber={1}'
						format: {id}) ]
]
