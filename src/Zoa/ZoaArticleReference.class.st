"
I represent an indirection. 
"
Class {
	#name : #ZoaArticleReference,
	#superclass : #Object,
	#instVars : [
		'reference',
		'title'
	],
	#category : #'Zoa-Model'
}

{ #category : #accessing }
ZoaArticleReference >> ensureIsLoadedInto: aZoaApi [

	| article |
	article := aZoaApi loadAndSaveArticle: reference.
	reference := article doi.
	^ article
]

{ #category : #accessing }
ZoaArticleReference >> isResolvedIn: aZoaApi [

	^ aZoaApi
		  ifArticleIsLoaded: reference
		  then: [ true ]
		  ifNot: [ false ]
]

{ #category : #accessing }
ZoaArticleReference >> reference: aReference [

	reference := aReference
]

{ #category : #accessing }
ZoaArticleReference >> referenceEntry: aZoaApi [
	^ (aZoaApi
		  ifArticleIsLoaded: reference
		  then: [ :article | 
			  (article date year asString , '-' , article firstAuthorCiteName
			   , ' -' , article title)  ]
		  ifNot: [ title , ' (' , reference , ')' ])readStream next: 150
]

{ #category : #accessing }
ZoaArticleReference >> refersTo: anArticle [

	^ reference = anArticle doi
]

{ #category : #accessing }
ZoaArticleReference >> title: aTitle [
	title := aTitle
]
