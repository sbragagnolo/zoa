"
Downloads from Research gate
"
Class {
	#name : #ZoaResearchGateLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaResearchGateLoader class >> loads: aString [
	^ (aString indexOfSubCollection: 'researchgate.net') > 0
]

{ #category : #'as yet unclassified' }
ZoaResearchGateLoader >> idFor: anUrl [
	^ ('_' split: anUrl segments last) first
]

{ #category : #'as yet unclassified' }
ZoaResearchGateLoader >> loadDocument: anUrl [
	| document bibtex |
	document := ZoaDocument new.
	document link: anUrl.
	bibtex := (ZnEasy
		get:
			('https://www.researchgate.net/lite.publication.PublicationDownloadCitationModal.downloadCitation.html?fileType=BibTeX&citation=citation-abstract&publicationUid={1}'
				format: {('_' split: anUrl segments last) first})) entity.
	self loadBibtex: bibtex into: document.
	self ensureDoiOn: document id: (self idFor: anUrl).
	^ document
]
