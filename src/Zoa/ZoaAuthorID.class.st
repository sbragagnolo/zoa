Class {
	#name : #ZoaAuthorID,
	#superclass : #Object,
	#instVars : [
		'authority',
		'id'
	],
	#category : #'Zoa-Loader'
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
