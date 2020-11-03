"
I represent some kind of Brief. A brief is resume or comment on some aspect of an article or a review. 
"
Class {
	#name : #ZoaBrief,
	#superclass : #Object,
	#instVars : [
		'order',
		'name',
		'text',
		'tags',
		'includeInText'
	],
	#category : #'Zoa-Model'
}

{ #category : #adding }
ZoaBrief >> addTag: aZoaTag [

	tags add: aZoaTag
]

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

{ #category : #accessing }
ZoaBrief >> order [
	^ order
]

{ #category : #accessing }
ZoaBrief >> order: anOrder [
	order := anOrder
]

{ #category : #removing }
ZoaBrief >> removeTag: aZoaTag [

	tags remove: aZoaTag
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
