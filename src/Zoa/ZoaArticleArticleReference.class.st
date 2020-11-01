"
I represent a reference from article to an article. 

In from we find the source of a paper reference. 
In to we find a paper citation
"
Class {
	#name : #ZoaArticleArticleReference,
	#superclass : #Object,
	#instVars : [
		'text',
		'fromReference',
		'toReference'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaArticleArticleReference class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaArticleArticleReference' yourself
]

{ #category : #voyage }
ZoaArticleArticleReference class >> isVoyageRoot [
	^ true
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> = aZoaRef [

	^ self species = aZoaRef species and: [ 
		  fromReference = aZoaRef fromReference and: [ 
			  toReference = aZoaRef toReference ] ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> citedBy: anArticle [

	^ fromReference refersTo: anArticle
	
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> cites: aZoaArticle [

	^ toReference  respondsTo: aZoaArticle
]

{ #category : #accessing }
ZoaArticleArticleReference >> fromReference [

	^ fromReference
]

{ #category : #accessing }
ZoaArticleArticleReference >> fromReference: aReference [ 
	fromReference := aReference
]

{ #category : #accessing }
ZoaArticleArticleReference >> getAllReferences [

	^ { 
		  fromReference.
		  toReference }
]

{ #category : #accessing }
ZoaArticleArticleReference >> getAllReferencesWith: aZoaAPI [

	^ { 
		  (aZoaAPI findArticle: fromReference).
		  (aZoaAPI findArticle: toReference) }
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> hasResolvedReference [

	^ toReference isResolved and: [ fromReference isResolved ]
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> hasResolvedReferenceIn: zoaApi [

	^ (toReference isResolvedIn: zoaApi) and: [ fromReference isResolvedIn: zoaApi ]
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> hash [
	^ fromReference hash bitXor: toReference hash
]

{ #category : #testing }
ZoaArticleArticleReference >> isRelatedWith: aZoaArticle [

	^ (fromReference refersTo: aZoaArticle) or: [ 
		  toReference refersTo: aZoaArticle ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> key [
	^ text
]

{ #category : #accessing }
ZoaArticleArticleReference >> printOn: aStream [
	aStream
		nextPutAll: 'REF:';
		nextPutAll: text
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> reference [
	self halt 
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> referenceEntryInRelationWith: anArticle zoa: aZoaApi [
	^ (fromReference refersTo: anArticle)
		  ifTrue: [ toReference referenceEntry: aZoaApi ]
		  ifFalse: [ fromReference referenceEntry: aZoaApi ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> text: aString [ 
	text := aString
]

{ #category : #accessing }
ZoaArticleArticleReference >> to: anArticle [
	to := anArticle
]

{ #category : #accessing }
ZoaArticleArticleReference >> toReference [

	^ toReference
]

{ #category : #accessing }
ZoaArticleArticleReference >> toReference: aReference [ 
	toReference := aReference
]

{ #category : #accessing }
ZoaArticleArticleReference >> value [ 
	^ self halt 
]
