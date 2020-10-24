Class {
	#name : #ZoaArticleArticleReference,
	#superclass : #Object,
	#instVars : [
		'text',
		'reference',
		'from',
		'to'
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
		  reference = aZoaRef reference ]
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> arrayKeywords [

	^ to ifNotNil: [ to keywords ] ifNil: [ {  } ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> citedBy: anArticle [

	^ from = anArticle
		  ifTrue: [ true ]
		  ifFalse: [ 
			  anArticle = to
				  ifTrue: [ false ]
				  ifFalse: [ 
				  self error: 'The article is not related with this reference ' ] ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> from [
	^ from
]

{ #category : #accessing }
ZoaArticleArticleReference >> from: anArticle [
	from := anArticle
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> hasResolvedReference [ 
	^ to isNotNil
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> hash [
	^ reference hash
]

{ #category : #testing }
ZoaArticleArticleReference >> isRelatedWith: aZoaArticle [

	^ from = aZoaArticle or: [ to = aZoaArticle ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> key [
	^ text
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> oppositeArticleTo: anArticle [

	^ from = anArticle
		  ifTrue: [ self to ]
		  ifFalse: [ self from ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> printOn: aStream [
	aStream
		nextPutAll: 'REF:';
		nextPutAll: text
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> reference [
	^ reference
]

{ #category : #accessing }
ZoaArticleArticleReference >> reference: aString [
	reference := aString
]

{ #category : #'as yet unclassified' }
ZoaArticleArticleReference >> referenceEntryInRelationWith: anArticle [

	^from = anArticle
		ifTrue: [ 
			(to ifNil: [ reference ] ifNotNil: [ 
				 to date year asString , '-' , to firstAuthorCiteName , ' -'
				 , to title ]) readStream next: 50 ]
		ifFalse: [ 
			(from ifNil: [ reference ] ifNotNil: [ 
				 from date year asString , '-' , from firstAuthorCiteName , ' -'
				 , from title ]) readStream next: 50 ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> text: aString [ 
	text := aString
]

{ #category : #accessing }
ZoaArticleArticleReference >> to [

	^ to ifNil: [ 
		to := Zoa current loadAndSaveArticleDoi: reference.
		from references remove: self .
		from references add: self. 
		Zoa current saveArticle: from.
		to
	 ]
]

{ #category : #accessing }
ZoaArticleArticleReference >> to: anArticle [
	to := anArticle
]

{ #category : #accessing }
ZoaArticleArticleReference >> value [ 
	^ reference 
]
