"
I represent an author id. I include an authority (such as ORCID, acm, google scholar etc) and the identifier within this domain. 
"
Class {
	#name : #ZoaAuthorID,
	#superclass : #Object,
	#instVars : [
		'authority',
		'id'
	],
	#category : #'Zoa-Model'
}

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> acm: anId [

	^ self authority: #ACM id: anId
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> arxiv: anId [

	^ self authority: #ARXIV id: anId
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> authority: anAuthority id: anId [

	^ self new
		  authority: anAuthority;
		  id: anId;
		  yourself
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> ieee: anId [ 
	^ self authority: #IEEE id: anId

]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> orcid: anId [

	^ self authority: #ORCID id: anId
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> researchgate: anId [

	^ self authority: #RESEARCHGATE id: anId
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> springer: anId [

	^ self authority: #SPRINGER id: anId
]

{ #category : #'as yet unclassified' }
ZoaAuthorID class >> unknown: anId [

	^ self authority: #UNKNOWN id: anId
]

{ #category : #accessing }
ZoaAuthorID >> = otherId [

	^ self species = otherId species and: [ 
		  authority = otherId authority and: [ id = otherId id ] ]
]

{ #category : #accessing }
ZoaAuthorID >> authority [
	^ authority
]

{ #category : #accessing }
ZoaAuthorID >> authority: aString [ 
	authority := aString
]

{ #category : #accessing }
ZoaAuthorID >> hash [

	^ authority hash bitXor: id hash
]

{ #category : #accessing }
ZoaAuthorID >> id [
	^ id
]

{ #category : #accessing }
ZoaAuthorID >> id: aString [ 
	id := aString
]

{ #category : #accessing }
ZoaAuthorID >> printOn: aStream [

	aStream
		nextPutAll: id asString;
		nextPutAll: '@';
		nextPutAll: authority
]
