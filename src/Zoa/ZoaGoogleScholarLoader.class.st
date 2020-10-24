Class {
	#name : #ZoaGoogleScholarLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaGoogleScholarLoader class >> loads: aString [
	^ aString = 'scholar.google.com'
]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarLoader >> loadDocument: aZnUrl [

	| entity html visitor |
	entity := (ZnEasy get: aZnUrl) entity.
	html := entity contents parseHTML.
	visitor := ZoaGoogleScholarVisitor new.
	html acceptNodeVisitor: visitor.
	^ visitor loadDocument
]
