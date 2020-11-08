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
	
]

{ #category : #accessing }
ZoaArticle >> addBrief: aBrief [

	briefs add: aBrief.
	aBrief order: (aBrief order ifNil: [ briefs size ])
]

{ #category : #accessing }
ZoaArticle >> addKeyword: aKeyword [
 	self keywords add: aKeyword .
"	aKeyword addArticle: self"
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
	^ (self firstAuthor) asString , (self date year \\ 1000) asString
]

{ #category : #accessing }
ZoaArticle >> citedByUsing: aZoa [
	^ aZoa allIncomingReferencesTo: self  
]

{ #category : #accessing }
ZoaArticle >> citesUsing: aZoa [

	^ aZoa allOutgoingReferencesFrom: self
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
ZoaArticle >> firstAuthor [

	^ authorsReference
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ authorsReference first ]
]

{ #category : #'as yet unclassified' }
ZoaArticle >> firstAuthorCiteName [

	^ authorsReference
		  ifEmpty: [ 'None Author found' ]
		  ifNotEmpty: [ authorsReference first authorIds asString ]
]

{ #category : #'as yet unclassified' }
ZoaArticle >> firstAuthorName [

	^ authorsReference
		  ifEmpty: [ 'None Author found' ]
		  ifNotEmpty: [ authorsReference first authorIds asString ]
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

	^ keywords ifNil: [ keywords := Set new ]
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
	
]

{ #category : #reference }
ZoaArticle >> microdownBriefUsing: aZoa [

	| authors |
	^ String streamContents: [ :str | 
		  str newLine
			  nextPutAll: '#';
			  nextPutAll: self title;
			  newLine.
		  str
			  nextPutAll: '##Citing';
			  newLine;
			  nextPutAll: self cite;
			  newLine.
		  str
			  newLine;
			  nextPutAll: '##Authors';
			  newLine.

		  authorsReference do: [ :ar | 
			  str
				  nextPutAll: 'Auhor Name: ';
				  nextPutAll: (aZoa findAuthorByIds: ar authorIds) fullName;
				  newLine.
			  str nextPutAll: 'Auhor ID: '.
			  ar authorIds do: [ :id | 
				  str
					  nextPutAll: id asString;
					  nextPutAll: '; ' ].
			  str newLine.
			  str nextPutAll: 'Auhor Affiliations:  '.
			  ar affiliation do: [ :a | 
				  str
					  nextPutAll: a;
					  nextPutAll: '; ' ].



			  str newLine ].

		  self abstract ifNotNil: [ 
			  str
				  newLine;
				  nextPutAll: '##Abstract';
				  newLine;
				  nextPutAll: self abstract;
				  newLine ].

		  str
			  nextPutAll: '##Keywords';
			  newLine.
		  str nextPutAll:
			  (';' join: (self keywords collect: [ :k | k name ])).
		  str newLine.
		  self briefs do: [ :b | 
			  b includeInText ifTrue: [ 
				  str
					  nextPutAll: '##';
					  nextPutAll: b name;
					  newLine;
					  nextPutAll: b text;
					  newLine.

				  b tags ifNotEmpty: [ 
					  str
						  nextPutAll: '###Tags';
						  nextPutAll: (';' join: (b tags collect: [ :k | k name ]));
						  newLine ] ] ].
		  str
			  newLine;
			  nextPutAll: '##References';
			  newLine.
		  str
			  nextPutAll: '###This article is cited by';
			  newLine.
		  (self citedByUsing: aZoa) do: [ :r | 
			  str
				  nextPutAll: ' ';
				  nextPutAll: (r referenceEntryInRelationWith: self zoa: aZoa);
				  newLine ].
		  str
			  nextPutAll: '###This article Cites';
			  newLine.
		  (self citesUsing: aZoa) do: [ :r | 
			  str
				  nextPutAll: ' ';
				  nextPutAll:
					  ((r referenceEntryInRelationWith: self zoa: aZoa) readStream 
						   next: 40);
				  newLine ].

		  str
			  newLine;
			  nextPutAll: '##Article Metadata';
			  newLine.
		  data associationsDo: [ :a | 
			  str
				  nextPutAll: a key asString;
				  nextPutAll: ' ';
				  nextPutAll: a value asString;
				  newLine ] ]
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
ZoaArticle >> pdfFileUsing: aZoa [
	^ aZoa pdfFileFor: self 
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
ZoaArticle >> removeBrief: aBrief [
	
	briefs remove: aBrief.

]

{ #category : #accessing }
ZoaArticle >> removeKeyword: aKeyword [
 	keywords remove: aKeyword .
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
