"
Article node .Is a grafoscopio node for documents
"
Class {
	#name : #ZoaArticleNode,
	#superclass : #GrafoscopioUrlCachedNode,
	#instVars : [
		'document',
		'children'
	],
	#category : #'Zoa-Grafoscopio'
}

{ #category : #'as yet unclassified' }
ZoaArticleNode >> article [
	^ super content
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> asTreeNodePresenter [
	| node | 
	node := TreeNodePresenter new.
	node
		hasChildren: [ self children isNotEmpty ];
		children: [ self children collect: [ :subNode | subNode asTreeNodePresenter ] ];
		content: self.
	^ node
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> body [
	^ self article
		ifNil: [ 'The given source ({1}) is not valid or currently unavailable '
				format: {link} ]
		ifNotNil: [ :article | article abstract ]
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> body: aCollection [ 

]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> buildPreorderCollection: aCollection [ 
	aCollection add: self. 
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> children [
	^ children
		ifNil: [ children := {(ZoaArticleViewerNode new
				parent: self;
				yourself)} ]
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> content [
	^ self body
]

{ #category : #accessing }
ZoaArticleNode >> document: aZoaDocument [ 
	content := aZoaDocument
]

{ #category : #accessing }
ZoaArticleNode >> fetchContent: aUrlOrDoi [
	| zoa |
	zoa := Zoa new.
	[ ^ (aUrlOrDoi beginsWith: 'http')
		ifTrue: [ zoa saveUrl: aUrlOrDoi asUrl ]
		ifFalse: [ zoa saveDoi: aUrlOrDoi ] ]
		on: Error
		do: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> getUrl [
	| url |
	url := UIManager default
		request: 'Please insert a url or DOI of the article '
		initialAnswer: 'http://'
		title: 'URL Node'.
	url ifNil: [ ^ nil ].
	^ url
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> header [
	^ self article 
		ifNil: [ ' Invalid link {1}' format: { link }  ]
		ifNotNil: [ :c | c title ].
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> isSelected [
	^ false
]

{ #category : #accessing }
ZoaArticleNode >> specModelClass [
	^ super specModelClass.
]

{ #category : #accessing }
ZoaArticleNode >> title [
	^ self header size > 30
		ifTrue: [ '[',self article cite,'] -', (self header readStream next: 22) , '...' ]
		ifFalse: [ self header ]
]
