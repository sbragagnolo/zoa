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
		'date',
		'abstract',
		'title',
		'doi',
		'keywords',
		'data',
		'cite',
		'type',
		'references',
		'authorsReference',
		'publisher',
		'containerTitle'
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

{ #category : #accessing }
ZoaArticle >> addKeyword: aKeyword [
 	keywords add: aKeyword .
	aKeyword addArticle: self
]

{ #category : #reference }
ZoaArticle >> addReference: aZoaArticleArticleReference [ 
	references add: aZoaArticleArticleReference.
]

{ #category : #accessing }
ZoaArticle >> affiliations [

	^ authorsReference flatCollect:  [ :a | a affiliation ]
]

{ #category : #accessing }
ZoaArticle >> allReferences [ 
	^ Zoa current allReferencesRelatedWith: self
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
ZoaArticle >> authorsReferences [
	^ authorsReference
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
	^ (self firstAuthorCiteName) , (self date year \\ 1000) asString
]

{ #category : #accessing }
ZoaArticle >> cite: aCite [
	^ cite := aCite
]

{ #category : #accessing }
ZoaArticle >> citedBy [ 
	^ Zoa current allIncomingReferencesTo: self  
]

{ #category : #accessing }
ZoaArticle >> cites [ 
	^ Zoa current allOutgoingReferencesFrom: self 
]

{ #category : #accessing }
ZoaArticle >> conference [
	^ data at: #conference ifAbsent: [  'Not a conference' ]
]

{ #category : #accessing }
ZoaArticle >> conference: aString [
	data at: #conference put: aString
]

{ #category : #'as yet unclassified' }
ZoaArticle >> containerTitle: aString [ 
	containerTitle:= aString
]

{ #category : #accessing }
ZoaArticle >> data [
	^ data
]

{ #category : #accessing }
ZoaArticle >> date [
	^ date ifNil: [ DateAndTime new  ]
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

{ #category : #accessing }
ZoaArticle >> fileBasename [

	self doi ifEmpty: [ 
		^ date year asString , '-' ,( self firstAuthorCiteName copyReplaceAll: ' ' with: '_') , '-'
		  , ((title copyReplaceAll: ' ' with: '-') readStream next: 20) ].
	^ (self doi copyReplaceAll: '\' with: '-')
		  copyReplaceAll: '/'
		  with: '-'
]

{ #category : #'as yet unclassified' }
ZoaArticle >> firstAuthorCiteName [

	^ authorsReference
		  ifEmpty: [ 'UnknownAuthor' ]
		  ifNotEmpty: [ authorsReference first author citeName ]
]

{ #category : #'as yet unclassified' }
ZoaArticle >> firstAuthorName [

	^ authorsReference
		  ifEmpty: [ 'None Author found' ]
		  ifNotEmpty: [ authorsReference first author fullName ]
]

{ #category : #accessing }
ZoaArticle >> getAllReferences [
	^ references
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
	keywords := aCollection asOrderedCollection 
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
	title ifNil: [ title := aZoaArticle title ].
	self references ifEmpty: [ 
		aZoaArticle references do: [ :r | 
			self addReference: r ].
		aZoaArticle references removeAll ].
	date ifNil: [ date := aZoaArticle date  ]. 
	 self halt
]

{ #category : #reference }
ZoaArticle >> microdownBrief [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: '#';
			  nextPutAll: self title;
			  cr.
		  str
			  nextPutAll: '##Citing';
			  cr;
			  nextPutAll: self cite;
			  cr.
		  str
			  cr;
			  nextPutAll: '##Authors';
			  cr.

		  authorsReference do: [ :ar | 
			  str nextPutAll: ar author fullName.
			  ar author ids keysAndValuesDo: [ :k :v | 
				  str
					  nextPutAll: k;
					  nextPutAll: ': ';
					  nextPutAll: v asString;
					  cr ].

			  str cr ].

		  self abstract ifNotNil: [ 
			  str
				  cr;
				  nextPutAll: '##Abstract';
				  cr;
				  nextPutAll: self abstract;
				  cr ].

		  str
			  nextPutAll: '##Keywords';
			  cr.
		  str nextPutAll:
			  (';' join: (self keywords collect: [ :k | k name ])).

		  self briefs do: [ :b | 
			  b includeInText ifTrue: [ 
				  str
					  nextPutAll: '##';
					  nextPutAll: b name;
					  cr;
					  nextPutAll: b text;
					  cr.

				  b tags ifNotEmpty: [ 
					  str
						  nextPutAll: '###Tags';
						  nextPutAll: (';' join: (b tags collect: [ :k | k name ]));
						  cr ] ] ].
		  str
			  cr;
			  nextPutAll: '##References';
			  cr.
		  str
			  nextPutAll: '###This article is cited by';
			  cr.
		  self citedBy do: [ :r | 
			  str
				  nextPutAll: ' ';
				  nextPutAll: (r referenceEntryInRelationWith: self zoa: Zoa current );
				  cr ].
		  str
			  nextPutAll: '###This article Cites';
			  cr.
		  self cites do: [ :r | 
			  str
				  nextPutAll: ' ';
				  nextPutAll: (r referenceEntryInRelationWith: self zoa: Zoa current );
				  cr ].

		  str
			  cr;
			  nextPutAll: '##Article Metadata';
			  cr.
		  data associationsDo: [ :a | 
			  str
				  nextPutAll: a key asString;
				  nextPutAll: ' ';
				  nextPutAll: a value asString;
				  cr ] ]
]

{ #category : #acessing }
ZoaArticle >> name [
	^ self title
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
ZoaArticle >> pdfFile [
	^ Zoa current pdfFileFor: self 
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
	^ publisher ifNil: [ 'UNKNOWN' ]
]

{ #category : #accessing }
ZoaArticle >> publisher: aPublisherSymbol [
	publisher := aPublisherSymbol 
]

{ #category : #accessing }
ZoaArticle >> references [
	^ references
]

{ #category : #accessing }
ZoaArticle >> removeKeyword: aKeyword [
 	keywords remove: aKeyword .
	aKeyword removeArticle: self
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
	^ title ifNil: [ 'Unknown title!' ]
]

{ #category : #accessing }
ZoaArticle >> title: aString [ 
	title := aString
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
