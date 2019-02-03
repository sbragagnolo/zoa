Class {
	#name : #ZoaResearchGateLoader,
	#superclass : #ZoaLoader,
	#category : #Zoa
}

{ #category : #api }
ZoaResearchGateLoader class >> loads: aString [
	^ aString = 'researchgate.net'
]

{ #category : #'as yet unclassified' }
ZoaResearchGateLoader >> loadCitation: anId [
	^ (ZnEasy
		get:
			('https://www.researchgate.net/lite.publication.PublicationDownloadCitationModal.downloadCitation.html?fileType=BibTeX&citation=citation&publicationUid={1}'
				format: {anId})) entity
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
	^ document
]
