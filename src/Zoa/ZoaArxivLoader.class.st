"
Downloads from Arxiv
"
Class {
	#name : #ZoaArxivLoader,
	#superclass : #ZoaVisitorLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaArxivLoader class >> loads: aString [
	^ aString = 'arxiv.org'
]

{ #category : #api }
ZoaArxivLoader class >> publisher [
	^ #Arxiv
]

{ #category : #'as yet unclassified' }
ZoaArxivLoader >> createVisitor [

	^ ZoaArxivVisitor new
]

{ #category : #'as yet unclassified' }
ZoaArxivLoader >> idFor: aZnUrl [

	^ 'arxiv/' , aZnUrl segments last
]

{ #category : #'as yet unclassified' }
ZoaArxivLoader >> loadDocument: anUrl [

	| arxiv article |
	arxiv := self idFor: anUrl.
	article := super loadDocument: anUrl.
	article arxivId: arxiv.
	article doi ifNil: [ article doi: arxiv ].
	^ article 
]
