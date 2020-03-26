"
Article node .Is a grafoscopio node for documents
"
Class {
	#name : #ZoaArticleNode,
	#superclass : #GrafoscopioUrlNode,
	#instVars : [
		'document',
		'children'
	],
	#category : #'Zoa-Grafoscopio'
}

{ #category : #'instance creation' }
ZoaArticleNode class >> nameForSelection [
	^ 'New Article Node'
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> article [
	| article |
	article := super content.
	^ article isString
		ifTrue: [ nil ]
		ifFalse: [ article ]
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
		ifTrue: [ zoa loadAndSaveArticleUrl: aUrlOrDoi asUrl ]
		ifFalse: [ zoa loadAndSaveArticleDoi: aUrlOrDoi ] ]
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
ZoaArticleNode >> hasAncestorTaggedAs: aString [
	^ parent hasAncestorTaggedAs: aString
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> header [
	^ self article 
		ifNil: [ ' Invalid link {1}' format: { link }  ]
		ifNotNil: [ :c | c title ].
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> isLeaf [
	^ false.
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> isSelected [
	^ false
]

{ #category : #markdown }
ZoaArticleNode >> markdownContent [
	^ String
		streamContents: [ :stream | 
			self writeTitleAsMarkdown: stream.
			self writeBodyAsMarkdown: stream.
			self writeBriefsAsMarkDown: stream ]
]

{ #category : #accessing }
ZoaArticleNode >> reload [
	content := Zoa new findByDoi: content doi
]

{ #category : #accessing }
ZoaArticleNode >> specModelClass [
	^ super specModelClass.
]

{ #category : #accessing }
ZoaArticleNode >> title [
	| ht |
	ht := self header.
	^ (ht size > 30 and: [ (ht beginsWith: ' Invalid link') not ])
		ifTrue: [ '[' , self article cite , '] -' , (self header readStream next: 22)
				, '...' ]
		ifFalse: [ ht ]
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> writeBodyAsMarkdown: aWriteStream [ 
	aWriteStream nextPutAll: self body asString withInternetLineEndings; crlf; crlf 
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> writeBriefsAsMarkDown: aStream [
	self article briefs
		select: [ :b | b includeInText ]
		thenDo: [ :b | 
			self level + 1 timesRepeat: [ aStream nextPutAll: '#' ].
			aStream nextPutAll: ' '.
			aStream
				nextPutAll: (b name copyReplaceTokens: #cr with: #lf);
				crlf;
				crlf.
			aStream nextPutAll: b text ]
]

{ #category : #'as yet unclassified' }
ZoaArticleNode >> writeTitleAsMarkdown: aStream [
	"I export the header as markdown using the level inside the tree to determine hierarchy
	and replacing all line endings to make them Internet friendly"

	self level timesRepeat: [ aStream nextPutAll: '#' ].
	aStream nextPutAll: ' '.
	aStream
		nextPutAll: (self article title copyReplaceTokens: #cr with: #lf);
		crlf;
		crlf
]
