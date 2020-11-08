"
I represent a research question to be reposnded by a review. 
"
Class {
	#name : #ZoaQuestion,
	#superclass : #Object,
	#instVars : [
		'id',
		'text',
		'unit',
		'codifications'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaQuestion >> codifications [
	^ codifications
]

{ #category : #initialization }
ZoaQuestion >> id [ 
	^ id
]

{ #category : #initialization }
ZoaQuestion >> initialize [ 
	super initialize. 
	id := UUID new. 
	text := ''.
	codifications := OrderedCollection new. 
	unit := #String. 
	
]

{ #category : #accessing }
ZoaQuestion >> text [
	^ text
]

{ #category : #accessing }
ZoaQuestion >> text: aCollection [ 
	text := aCollection
]

{ #category : #accessing }
ZoaQuestion >> unit [
	^ unit
]

{ #category : #accessing }
ZoaQuestion >> unit: aString [ 
	unit := aString
]
