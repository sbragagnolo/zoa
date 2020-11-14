Class {
	#name : #ZoaWileyVisitor,
	#superclass : #ZoaHTMLVisitor,
	#instVars : [
		'author',
		'affiliations'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaWileyVisitor >> attribute: att inElement: anElement [

	^ (anElement attributeAt: att ifAbsent: '') 
]

{ #category : #visiting }
ZoaWileyVisitor >> attribute: att inElement: anElement beginsWith: string [

	^ (anElement attributeAt: att ifAbsent: '') includesSubstring:  string
]

{ #category : #visiting }
ZoaWileyVisitor >> isACite: anElement [

	^ self element: anElement isType: 'li' andClass: 'citedByEntry'
]

{ #category : #visiting }
ZoaWileyVisitor >> isAReference: anElement [

	^ self element: anElement hasClass: 'creative-work'
]

{ #category : #visiting }
ZoaWileyVisitor >> isAbstract: anElement [

	^ (self isMetaElement: anElement) and: [ 
		  self
			  attribute: 'name'
			  inElement: anElement
			  beginsWith: 'Description' ]
]

{ #category : #visiting }
ZoaWileyVisitor >> isArticleMetadata: anElement [

	^ (self isMetaElement: anElement) and: [ 
		  | name |
		  name := self attribute: 'name' inElement: anElement.
		  (name beginsWith: 'citation') and: [ 
			  (name includesSubstring: 'author') not and: [ 
				  (name includesSubstring: 'keywords') not  ] ] ]
]

{ #category : #visiting }
ZoaWileyVisitor >> isAuthorMetadata: anElement [

	^ (self isMetaElement: anElement) and: [ 
		 self attribute: 'name' inElement: anElement beginsWith: 'citation_author' .
		 ]
]

{ #category : #visiting }
ZoaWileyVisitor >> isKeywordMetadata: anElement [

	^ (self isMetaElement: anElement) and: [ 
		 self attribute: 'name' inElement: anElement beginsWith: 'citation_keywords' .
		 ]
]

{ #category : #visiting }
ZoaWileyVisitor >> isMetaElement: anElement [

	^ anElement name = 'meta'
]

{ #category : #visiting }
ZoaWileyVisitor >> processAbstract: anElement [

	article abstract: (self attribute: 'content' inElement: anElement)
]

{ #category : #visiting }
ZoaWileyVisitor >> processArticleMetadata: anElement [

	| selector data |
	selector := ((self attribute: 'name' inElement: anElement)
		             copyReplaceAll: 'citation_'
		             with: '') , ':'.
	selector := '_' split: selector.
	selector := (selector first
	             ,
	             ('' join:
		              (selector allButFirst collect: [ :s | s capitalized ])))
		            asSymbol.
	data := self attribute: 'content' inElement: anElement.
	(article respondsTo: selector)
		ifTrue: [ article perform: selector withArguments: { data } ]
		ifFalse: [ 
			loader
				perform: ('set{1}into:' format: { selector capitalized }) asSymbol
				withArguments: { 
						data.
						article } ]
]

{ #category : #visiting }
ZoaWileyVisitor >> processAuthorOrAuthorAffiliation: anElement [

	(self attribute: 'name' inElement: anElement)
	= #citation_author_institution ifTrue: [ 
		self assert: author isNotNil.
		affiliations := self attribute: 'content' inElement: anElement.
		self pushAuthor ].
	(self attribute: 'name' inElement: anElement) = #citation_author 
		ifTrue: [ 
			author ifNotNil: [ 
				self pushAuthor "Author without affiliation passed before " ].
			author := self attribute: 'content' inElement: anElement ]
]

{ #category : #visiting }
ZoaWileyVisitor >> processCite: anElement [

	| text reference fromReference toReference |
	text := ' ' join: (self detectStringElement: anElement).
	reference := self detectHrefToArticle: anElement.
	reference ifNil: [ ^ self ].

	toReference := ZoaArticleReference new
		               reference: article doi;
		               title: article title;
		               yourself.

	fromReference := ZoaArticleReference new
		                 reference: reference;
		                 title: text;
		                 yourself.


	^ self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaWileyVisitor >> processElement: anElement [ 
	(self isArticleMetadata: anElement) ifTrue: [ 
		self processArticleMetadata: anElement ].
	(self isAuthorMetadata: anElement) ifTrue: [ 
		self processAuthorOrAuthorAffiliation: anElement ].
	(self isKeywordMetadata: anElement) ifTrue: [ 
		self processKeyword: anElement ].
	(self isAbstract: anElement) ifTrue: [ 
		self processAbstract: anElement ].
	(self isAReference: anElement) ifTrue: [ 
		self processReference: anElement ].
	(self isACite: anElement) ifTrue: [ self processCite: anElement ]
]

{ #category : #visiting }
ZoaWileyVisitor >> processKeyword: anElement [

	| name |
	name := self attribute: 'content' inElement: anElement.

	article addKeyword: (ZoaTag new
			 name: name;
			 yourself)
]

{ #category : #visiting }
ZoaWileyVisitor >> processReference: anElement [

	| text reference fromReference toReference |

	text := ' ' join: (self detectStringElement: anElement).
	reference := self detectHrefToArticle: anElement.

	reference ifNil: [ ^ self ].
	(reference beginsWith: 'full/') ifTrue: [ 
		reference := reference copyReplaceAll: 'full/' with: '' ].
	fromReference := ZoaArticleReference new
		                 reference: article doi;
		                 title: article title;
		                 yourself.

	toReference := ZoaArticleReference new
		               reference: reference;
		               title: text;
		               yourself.


	^ self addReferenceFrom: fromReference to: toReference
]

{ #category : #visiting }
ZoaWileyVisitor >> pushAuthor [

	| stream |
	stream := author readStream.
	affiliations ifNil: [ affiliations := 'Unknown' ].
	loader
		addTo: article
		authorFirstNamed: (stream upToAll: ' ')
		lastName: stream upToEnd
		id: (ZoaAuthorID wiley: author)
		affiliations: { affiliations }.
	author := nil.
	affiliations := nil
]

{ #category : #'as yet unclassified' }
ZoaWileyVisitor >> setJournalTitle: aString into: aZoaArticle [ 
	self shouldBeImplemented.
]
