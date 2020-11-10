"
I am a loader based on google scholar. 
I do delagate directly to a visitor that delegates to the proper library .
"
Class {
	#name : #ZoaGoogleScholarLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaGoogleScholarLoader class >> loads: aString [
	^ aString = 'scholar.google.com'
]

{ #category : #api }
ZoaGoogleScholarLoader class >> publisher [
	^ self error: 'Google scholar is not publisher'
]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarLoader >> loadDocument: aZnUrl [

	| entity html visitor |
	entity := (ZnEasy get: aZnUrl) entity.
	html := entity contents parseHTML.
	visitor := ZoaGoogleScholarVisitor new.
	visitor zoa: zoa. 
	html acceptNodeVisitor: visitor.
	^ visitor loadDocument
]
