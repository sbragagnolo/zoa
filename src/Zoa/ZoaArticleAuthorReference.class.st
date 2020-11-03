"
I represent an authro reference. I link an article to an author, accounting the affiliations
"
Class {
	#name : #ZoaArticleAuthorReference,
	#superclass : #Object,
	#instVars : [
		'articleReference',
		'affiliation',
		'authorIds'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaArticleAuthorReference >> = anOtherRef [

	^ self species = anOtherRef species and: [ 
		  articleReference = anOtherRef articleReference and: [ 
			  authorIds = anOtherRef authorIds ] ]
]

{ #category : #adding }
ZoaArticleAuthorReference >> addAffiliation: aString [ 
	affiliation  add: aString 
]

{ #category : #accessing }
ZoaArticleAuthorReference >> affiliation [

	^ affiliation ifNil: [ affiliation := Set new ]
]

{ #category : #accessing }
ZoaArticleAuthorReference >> affiliation: aString [
	aString ifNil: [ ^ self  ].
	affiliation := (aString isString
		                ifTrue: [ { aString } ]
		                ifFalse: [ aString ]) asSet
]

{ #category : #accessing }
ZoaArticleAuthorReference >> articleReference [
	^ articleReference 
]

{ #category : #accessing }
ZoaArticleAuthorReference >> articleReference: aZoaArticleRef [

	articleReference := aZoaArticleRef
]

{ #category : #'as yet unclassified' }
ZoaArticleAuthorReference >> authorIds [
	^ authorIds
]

{ #category : #accessing }
ZoaArticleAuthorReference >> authorIds: aZoaAuthorIdSet [
	authorIds := aZoaAuthorIdSet
]

{ #category : #accessing }
ZoaArticleAuthorReference >> hash [
	^ articleReference hash bitXor: authorIds hash
]

{ #category : #'as yet unclassified' }
ZoaArticleAuthorReference >> printOn: aStream [

	aStream nextPutAll: 'ArticleAuthorRef: ('.
	authorIds anyOne printOn: aStream.
	aStream nextPutAll: ';'.
	articleReference printOn: aStream.
	aStream nextPutAll: ')'
]
