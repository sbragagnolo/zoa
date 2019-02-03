Class {
	#name : #ZoaIEEELoader,
	#superclass : #ZoaLoader,
	#category : #Zoa
}

{ #category : #api }
ZoaIEEELoader class >> loads: aString [
	^ aString = 'ieeexplore.ieee.org'
]

{ #category : #'as yet unclassified' }
ZoaIEEELoader >> loadDocument: anUrl [
	| document bibtex segments id |
	document := ZoaDocument new.
	document link: anUrl.
	segments := anUrl asUrl segments copy.
	id := segments removeLast.
	[ id isAllDigits ] whileFalse: [ id := segments removeLast ].
	bibtex := (ZnEasy
		get:
			('https://ieeexplore.ieee.org/xpl/downloadCitations?recordIds={1}&download-format=download-bibtex&citations-format=citation-abstract'
				format: {id})) entity.
	self loadBibtex: bibtex into: document.
	^ document
]
