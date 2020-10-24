Class {
	#name : #ZoaQueryModel,
	#superclass : #Object,
	#instVars : [
		'articles',
		'owner'
	],
	#category : #'Zoa-UI'
}

{ #category : #'as yet unclassified' }
ZoaQueryModel >> articles [

	^ articles ifNil: [ Zoa current findAllArticles ]
]

{ #category : #'as yet unclassified' }
ZoaQueryModel >> articles: someArticles [

	articles := someArticles.
	owner updateViewers
]

{ #category : #accessing }
ZoaQueryModel >> owner: aSpCodePresenter [ 
	owner := aSpCodePresenter 
]

{ #category : #'as yet unclassified' }
ZoaQueryModel >> reset [

	self articles: nil
]

{ #category : #'as yet unclassified' }
ZoaQueryModel >> select: someArticles [

	| selection |
	 selection := (someArticles isCollection ifTrue: [ someArticles  ] ifFalse: [ { someArticles } ]).
	(selection allSatisfy: [ :a | a isKindOf: ZoaArticle ]) ifFalse: [ 
		self articles: nil.
		selection inspect.
		self error:
			'We can only select articles! Ensure that your query does not select other kind( nil included ) ' ].
	self articles: selection
]

{ #category : #'as yet unclassified' }
ZoaQueryModel >> zoa [
	^ Zoa current
]
