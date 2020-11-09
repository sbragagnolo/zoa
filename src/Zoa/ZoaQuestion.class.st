"
I represent a research question to be reposnded by a review. 
"
Class {
	#name : #ZoaQuestion,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'text',
		'unit',
		'codifications'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaQuestion >> adaptValueToUnit: aValue [
	unit = #String ifTrue: [ ^ aValue asString ].
	unit = #Number ifTrue: [ ^ aValue asNumber  ].
	unit = #Date ifTrue: [ ^ aValue asDate  ].
	^ self error: 'Unexpected unit'
]

{ #category : #accessing }
ZoaQuestion >> codifications [
	^ codifications
]

{ #category : #accessing }
ZoaQuestion >> defaultValueForUnit [

	unit = #String ifTrue: [ ^ '' ].
	unit = #Number ifTrue: [ ^ 0 ].
	unit = #Date ifTrue: [ ^ Date new ].
	^ self error: 'Unexpected unit'
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
ZoaQuestion >> name [
	^ name
]

{ #category : #accessing }
ZoaQuestion >> name: aRqName [

	name := aRqName
]

{ #category : #accessing }
ZoaQuestion >> readFrom: aDictionary [

	^ aDictionary at: id ifAbsent: [ self defaultValueForUnit ]
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

{ #category : #accessing }
ZoaQuestion >> write: aValue into: aDictionary [
	aDictionary at: id put: (self adaptValueToUnit: aValue)
]
