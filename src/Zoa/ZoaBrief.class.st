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
		'includeInText',
		'id'
	],
	#category : #'Zoa-Model'
}

{ #category : #initialization }
ZoaBrief >> = anOtherReview [

	^ self species = anOtherReview species and: [ id = anOtherReview id ]
]

{ #category : #adding }
ZoaBrief >> addTag: aZoaTag [

	tags add: aZoaTag
]

{ #category : #initialization }
ZoaBrief >> hash [

	^ id hash
]

{ #category : #initialization }
ZoaBrief >> id [
	^ id
]

{ #category : #accessing }
ZoaBrief >> includeInText [
	^ includeInText ifNil: [ false ]
]

{ #category : #accessing }
ZoaBrief >> includeInText: aValue [ 
	includeInText := aValue
]

{ #category : #initialization }
ZoaBrief >> initialize [

	super initialize.
	id := UUID new. 
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
