"
This entry represents a document (Article, whitepaper, etc)
"
Class {
	#name : #ZoaArticle,
	#superclass : #Object,
	#instVars : [
		'link',
		'briefs',
		'tags',
		'pdf',
		'date',
		'abstract',
		'title',
		'doi',
		'keywords',
		'data',
		'cite',
		'type',
		'references',
		'authorsReference'
	],
	#category : #'Zoa-Model'
}

{ #category : #voyage }
ZoaArticle class >> descriptionContainer [
	<voyageContainer>
	^ VOContainer new collectionName: 'ZoaArticle' yourself
]

{ #category : #voyage }
ZoaArticle class >> isVoyageRoot [
	^ true
]

{ #category : #accessing }
ZoaArticle >> = anOtherArticle [
	^ self species = anOtherArticle species
		and: [ doi = anOtherArticle doi ]
]

{ #category : #accessing }
ZoaArticle >> abstract [
	^ abstract
]

{ #category : #accessing }
ZoaArticle >> abstract: anObject [
	abstract := anObject
]

{ #category : #'as yet unclassified' }
ZoaArticle >> addAuthorReference: aZoaArticleAuthorReference [ 
	authorsReference add: aZoaArticleAuthorReference.
	aZoaArticleAuthorReference article: self
]

{ #category : #accessing }
ZoaArticle >> addBrief: aBrief [
	briefs add: aBrief
]

{ #category : #reference }
ZoaArticle >> addReference: aZoaArticleArticleReference [ 
	references add: aZoaArticleArticleReference.
	aZoaArticleArticleReference from: self.
]

{ #category : #accessing }
ZoaArticle >> arrayKeywords [
	^ self keywords asArray 
]

{ #category : #accessing }
ZoaArticle >> arrayTags [
	^ self tags asArray 
]

{ #category : #accessing }
ZoaArticle >> arxivId [
	^ data at:#arxiv
]

{ #category : #accessing }
ZoaArticle >> arxivId: aString [ 
	doi := aString. 
	data at: #arxiv put: aString
]

{ #category : #accessing }
ZoaArticle >> authors [
	^ authorsReference collect: [ : a | a author ]
]

{ #category : #accessing }
ZoaArticle >> authors: anObject [
	authorsReference := anObject
]

{ #category : #accessing }
ZoaArticle >> bibtex [
	^ String
		streamContents: [ :str | 
			str
				nextPut: $@;
				nextPutAll: self kind;
				nextPut: ${;
				nextPutAll: self cite;
				nextPut: $,;
				nextPutAll: String lf.
			data
				keysAndValuesDo: [ :k :v | 
					| val |
					val := (v isString not and: [ v isCollection ])
						ifTrue: [ ', ' join: v ]
						ifFalse: [ v asString ].
					k = #kind
						ifFalse: [ str
								nextPutAll: k;
								nextPut: $=;
								nextPut: ${;
								nextPutAll: val;
								nextPut: $};
								nextPut: $,;
								nextPutAll: String lf ] ].
			(self class instVarNames reject: [ :v | #(data tags briefs pdf) includes: v  ])
				do: [ :v | self stream: v into: str ] ]
]

{ #category : #'as yet unclassified' }
ZoaArticle >> body [
	self shouldBeImplemented.
]

{ #category : #accessing }
ZoaArticle >> booktitle: aString [ 
	data at: #booktitle put: aString
]

{ #category : #accessing }
ZoaArticle >> briefs [
	^ briefs ifNil: [ briefs := OrderedCollection new ]
]

{ #category : #accessing }
ZoaArticle >> briefs: anObject [
	briefs := anObject
]

{ #category : #'as yet unclassified' }
ZoaArticle >> children [
	^ {  }
]

{ #category : #'as yet unclassified' }
ZoaArticle >> cite [
	^ (self firstAuthor citeName) , (date year \\ 1000) asString
]

{ #category : #accessing }
ZoaArticle >> cite: aCite [
	^ cite := aCite
]

{ #category : #accessing }
ZoaArticle >> conference [
	^ data at: #conference ifAbsent: [  'Not a conference' ]
]

{ #category : #accessing }
ZoaArticle >> conference: aString [
	data at: #conference put: aString
]

{ #category : #accessing }
ZoaArticle >> data [
	^ data
]

{ #category : #accessing }
ZoaArticle >> date [
	^ date
]

{ #category : #accessing }
ZoaArticle >> date: anObject [
	date := anObject
]

{ #category : #accessing }
ZoaArticle >> doi [
	^ doi
]

{ #category : #accessing }
ZoaArticle >> doi: aString [ 
	doi := aString 
]

{ #category : #'as yet unclassified' }
ZoaArticle >> firstAuthor [
	^ authorsReference first
]

{ #category : #accessing }
ZoaArticle >> hash [
	^ doi hash
]

{ #category : #accessing }
ZoaArticle >> hashCite [
	^ (authorsReference first copyFrom: 1 to: 4) , (date year \\ 1000) asString
]

{ #category : #'as yet unclassified' }
ZoaArticle >> header [
	^ ''
]

{ #category : #accessing }
ZoaArticle >> initialize [
	super initialize.
	data := Dictionary new.
	briefs := OrderedCollection new.
	authorsReference := OrderedCollection new.
	references := OrderedCollection new.
]

{ #category : #accessing }
ZoaArticle >> isArxiv [
	^ data includesKey: #arxiv
]

{ #category : #'as yet unclassified' }
ZoaArticle >> isEmptyOrNil [
	^ false
]

{ #category : #accessing }
ZoaArticle >> isbn [
	^ data at:#isbn
]

{ #category : #accessing }
ZoaArticle >> isbn: aString [
	data at: #isbn put: aString
]

{ #category : #accessing }
ZoaArticle >> issn [
	^ data at: #isnn ifAbsent: [ nil ]
]

{ #category : #accessing }
ZoaArticle >> issn: aString [
	data at: #isnn put: aString
]

{ #category : #'as yet unclassified' }
ZoaArticle >> issue: aString [ 
	^ data at: #issue put: aString 
]

{ #category : #accessing }
ZoaArticle >> journal [
	^ data at: #journal
]

{ #category : #accessing }
ZoaArticle >> journal: aString [ 
	data at: #journal put: aString
]

{ #category : #accessing }
ZoaArticle >> keywords [
	^ keywords ifNil: [ ^ {} ]
]

{ #category : #accessing }
ZoaArticle >> keywords: aCollection [
	keywords := aCollection
]

{ #category : #accessing }
ZoaArticle >> kind [
	^ data at: #kind ifAbsent: [ 'UNKNOWN' ]
]

{ #category : #accessing }
ZoaArticle >> kind: anObject [
	data at: #kind put: anObject
]

{ #category : #accessing }
ZoaArticle >> link [
	^ link
]

{ #category : #accessing }
ZoaArticle >> link: anObject [
	link := anObject
]

{ #category : #'as yet unclassified' }
ZoaArticle >> mergeWith: aZoaArticle [ 
	self = aZoaArticle ifTrue: [ ^ self ].
	self halt. 
]

{ #category : #acessing }
ZoaArticle >> note: aString [
	data at: #note put: aString
]

{ #category : #accessing }
ZoaArticle >> number: anInteger [
	data at: #number put: anInteger
]

{ #category : #accessing }
ZoaArticle >> pages: aCollection [
	aCollection ifEmpty: [ ^ self ].
	data at: #pages put: (aCollection min to: aCollection max)
]

{ #category : #accessing }
ZoaArticle >> pdf [
	^ pdf
]

{ #category : #accessing }
ZoaArticle >> pdf: anObject [
	pdf := anObject
]

{ #category : #accessing }
ZoaArticle >> pdfContent [
	pdf
		ifNil: [ ^ self error: 'Unavailable content. execute getPdf before' ].
	^ pdf
]

{ #category : #accessing }
ZoaArticle >> pdfUrl [
	^ data at: #pdfUrl ifAbsent: [ nil ]
]

{ #category : #accessing }
ZoaArticle >> pdfUrl: aZnUrl [
	data at: #pdfUrl put: aZnUrl
]

{ #category : #accessing }
ZoaArticle >> printString [
	^ String
		streamContents: [ :str | 
			str
				nextPutAll: date year asString;
				nextPutAll: '|';
				nextPutAll: doi;
				nextPutAll: ' | ';
				nextPutAll: self cite;
				nextPutAll: ' | ';
				nextPutAll: self authors first;
				nextPutAll: ' | ';
				nextPutAll: self title;
				nextPutAll: ' | ';
				nextPutAll: self tags asArray asString;
				nextPutAll: ' | ';
				nextPutAll: self keywords asArray asString  ]
]

{ #category : #accessing }
ZoaArticle >> publisher [
	^ data at: #publisher ifAbsent: [ 'Non publisher' ]
]

{ #category : #accessing }
ZoaArticle >> publisher: aString [
	data at: #publisher put: aString
]

{ #category : #accessing }
ZoaArticle >> read [
	pdf
		ifNil: [ self error: 'Unavailable content. execute getPdf before' ].
	^ pdf
]

{ #category : #accessing }
ZoaArticle >> specModelClass [
	^ GrafoscopioNewTextModel
]

{ #category : #accessing }
ZoaArticle >> stream: aVar into: str [
	| val |
	val := self instVarNamed: aVar.
	val ifNil: [ ^ self ].
	val := (val isString not and: [ val isCollection ])
		ifTrue: [ ', ' join: val ]
		ifFalse: [ val asString ].
	str
		nextPutAll: aVar;
		nextPut: $=;
		nextPut: ${;
		nextPutAll: val;
		nextPut: $};
		nextPut: $,;
		nextPutAll: String lf
]

{ #category : #accessing }
ZoaArticle >> tags [
	^ tags ifNil: [ {} ]
]

{ #category : #accessing }
ZoaArticle >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
ZoaArticle >> title [
	^ title
]

{ #category : #accessing }
ZoaArticle >> title: aString [ 
	title := aString
]

{ #category : #'as yet unclassified' }
ZoaArticle >> todoNode: aTitle [
	^ GrafoscopioTextNode new
		header: aTitle;
		body: '#TODO Should add something here'
]

{ #category : #accessing }
ZoaArticle >> type: aString [
	self data at: #EventType put: aString
]

{ #category : #accessing }
ZoaArticle >> volume [
	^ data at: #volume
]

{ #category : #accessing }
ZoaArticle >> volume: anInteger [
	data at: #volume put: anInteger
]