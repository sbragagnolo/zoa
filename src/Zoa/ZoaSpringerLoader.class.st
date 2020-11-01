"
I load springer documents
"
Class {
	#name : #ZoaSpringerLoader,
	#superclass : #ZoaVisitorLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaSpringerLoader class >> loads: aString [

	^ aString includesSubstring: 'springer'
]

{ #category : #api }
ZoaSpringerLoader class >> publisher [
	^ #Springer
]

{ #category : #'as yet unclassified' }
ZoaSpringerLoader >> createVisitor [

	^ ZoaSpringerVisitor new
]

{ #category : #'as yet unclassified' }
ZoaSpringerLoader >> idFor: aZnUrl [


	^ '/' join:(aZnUrl segments last:2 )
]
