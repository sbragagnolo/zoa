"
Downloads from Arxiv
"
Class {
	#name : #ZoaArxivLoader,
	#superclass : #ZoaLoader,
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

{ #category : #accessing }
ZoaArxivLoader >> loadDocument: aDocument [
	self halt.
]

{ #category : #'as yet unclassified' }
ZoaArxivLoader >> privateAbstractFor: anUrl [
	| contents stream |
	contents := ZnEasy get: anUrl.
	stream := contents entity readStream.
	stream upToAll: 'Abstract:</span>'.
	^ stream upToAll: '</blockquote>'
]
