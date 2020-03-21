Class {
	#name : #ZoaElSevierLoader,
	#superclass : #ZoaLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaElSevierLoader class >> formatUrl: aZnUrl forDoi: aDoi [ 
	^ ('https://www.sciencedirect.com/science/article/abs/pii/' , aZnUrl segments last) asUrl 
]

{ #category : #api }
ZoaElSevierLoader class >> loads: aString [
	^ aString = 'linkinghub.elsevier.com'
]

{ #category : #'as yet unclassified' }
ZoaElSevierLoader >> loadDocument: anId [
	self error: ' This loader only works as proxy of science direct'

]
