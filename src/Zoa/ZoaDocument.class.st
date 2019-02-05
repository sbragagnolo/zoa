"
This entry represents a document (Article, whitepaper, etc)
"
Class {
	#name : #ZoaDocument,
	#superclass : #Object,
	#instVars : [
		'link',
		'briefs',
		'tags',
		'pdf',
		'authors',
		'date',
		'abstract',
		'title',
		'doi',
		'keywords',
		'data',
		'cite'
	],
	#category : #Zoa
}

{ #category : #accessing }
ZoaDocument >> abstract [
	^ abstract
]

{ #category : #accessing }
ZoaDocument >> abstract: anObject [
	abstract := anObject
]

{ #category : #accessing }
ZoaDocument >> arrayKeywords [
	^ self keywords asArray 
]

{ #category : #accessing }
ZoaDocument >> arrayTags [
	^ self tags asArray 
]

{ #category : #accessing }
ZoaDocument >> arxivId [
	^ data at:#arxiv
]

{ #category : #accessing }
ZoaDocument >> arxivId: aString [ 
	doi := aString. 
	data at: #arxiv put: aString
]

{ #category : #accessing }
ZoaDocument >> authors [
	^ authors
]

{ #category : #accessing }
ZoaDocument >> authors: anObject [
	authors := anObject
]

{ #category : #accessing }
ZoaDocument >> bibtex [
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

{ #category : #accessing }
ZoaDocument >> booktitle: aString [ 
	data at: #booktitle put: aString
]

{ #category : #accessing }
ZoaDocument >> briefs [
	^ briefs
]

{ #category : #accessing }
ZoaDocument >> briefs: anObject [
	briefs := anObject
]

{ #category : #accessing }
ZoaDocument >> cite [
	^ cite ifNil: [ self hashCite ]
]

{ #category : #accessing }
ZoaDocument >> cite: aCite [
	^ cite := aCite
]

{ #category : #accessing }
ZoaDocument >> conference [
	^ data at: #conference ifAbsent: [  'Not a conference' ]
]

{ #category : #accessing }
ZoaDocument >> conference: aString [
	data at: #conference put: aString
]

{ #category : #accessing }
ZoaDocument >> date [
	^ date
]

{ #category : #accessing }
ZoaDocument >> date: anObject [
	date := anObject
]

{ #category : #accessing }
ZoaDocument >> doi [
	^ doi
]

{ #category : #accessing }
ZoaDocument >> doi: aString [ 
	doi := aString 
]

{ #category : #accessing }
ZoaDocument >> hashCite [
	^ (authors first copyFrom: 1 to: 4)
		, (date year asString copyFrom: 3 to: 4) , '-' , self hash asString
]

{ #category : #accessing }
ZoaDocument >> initialize [
	super initialize.
	data := Dictionary new
]

{ #category : #accessing }
ZoaDocument >> isArxiv [
	^ data includesKey: #arxiv
]

{ #category : #accessing }
ZoaDocument >> isbn [
	^ data at:#isbn
]

{ #category : #accessing }
ZoaDocument >> isbn: aString [
	data at: #isbn put: aString
]

{ #category : #accessing }
ZoaDocument >> keywords [
	^ keywords ifNil: [ ^ {} ]
]

{ #category : #accessing }
ZoaDocument >> keywords: aCollection [
	keywords := aCollection
]

{ #category : #accessing }
ZoaDocument >> kind [
	^ data at: #kind ifAbsent: [ 'UNKNOWN' ]
]

{ #category : #accessing }
ZoaDocument >> kind: anObject [
	data at: #kind put: anObject
]

{ #category : #accessing }
ZoaDocument >> link [
	^ link
]

{ #category : #accessing }
ZoaDocument >> link: anObject [
	link := anObject
]

{ #category : #accessing }
ZoaDocument >> pages: aCollection [
	data at: #pages put: (aCollection min to: aCollection max)
]

{ #category : #accessing }
ZoaDocument >> pdf [
	^ pdf
]

{ #category : #accessing }
ZoaDocument >> pdf: anObject [
	pdf := anObject
]

{ #category : #accessing }
ZoaDocument >> pdfContent [
	pdf
		ifNil: [ ^ self error: 'Unavailable content. execute getPdf before' ].
	^ pdf
]

{ #category : #accessing }
ZoaDocument >> pdfUrl [
	^ data at: #pdfUrl
]

{ #category : #accessing }
ZoaDocument >> pdfUrl: aZnUrl [
	data at: #pdfUrl put: aZnUrl
]

{ #category : #accessing }
ZoaDocument >> printString [
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
ZoaDocument >> publisher [
	^ data at: #publisher ifAbsent: [ 'Non publisher' ]
]

{ #category : #accessing }
ZoaDocument >> publisher: aString [
	data at: #publisher put: aString
]

{ #category : #accessing }
ZoaDocument >> read [
	pdf
		ifNil: [ self error: 'Unavailable content. execute getPdf before' ].
	^ pdf
]

{ #category : #accessing }
ZoaDocument >> stream: aVar into: str [
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
ZoaDocument >> tags [
	^ tags ifNil: [ {} ]
]

{ #category : #accessing }
ZoaDocument >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
ZoaDocument >> title [
	^ title
]

{ #category : #accessing }
ZoaDocument >> title: aString [ 
	title := aString
]
