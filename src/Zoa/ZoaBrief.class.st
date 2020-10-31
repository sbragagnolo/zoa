"
I represent some kind of Brief. A brief is resume or comment on some aspect of an article or a review. 
"
Class {
	#name : #ZoaBrief,
	#superclass : #Object,
	#instVars : [
		'name',
		'text',
		'tags',
		'includeInText'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaBrief >> includeInText [
	^ includeInText ifNil: [ false ]
]

{ #category : #initialization }
ZoaBrief >> initialize [
	super initialize.
	text := ''.
	includeInText := false.
]

{ #category : #accessing }
ZoaBrief >> name [
	^ name
]

{ #category : #accessing }
ZoaBrief >> name: aString [ 
	name := aString
]

{ #category : #initialization }
ZoaBrief >> tags [
	^ tags ifNil: [ tags := OrderedCollection  new  ]
]

{ #category : #accessing }
ZoaBrief >> text [
	^ text ifEmpty: [ ^ '#', name ]
]

{ #category : #accessing }
ZoaBrief >> text: aString [ 
	text := aString
]

{ #category : #accessing }
ZoaBrief >> toggleIncludeInText [
	includeInText := self includeInText not
]
