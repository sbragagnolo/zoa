"
Loader is an abstract class that fetches a Zoa document
"
Class {
	#name : #ZoaLoader,
	#superclass : #Object,
	#instVars : [
		'zoa'
	],
	#category : #'Zoa-Loader'
}

{ #category : #'as yet unclassified' }
ZoaLoader class >> formatUrl: aZnUrl forDoi: aDoi [
	^ self = ZoaLoader
		ifTrue: [ (self loaderFor: aZnUrl host) formatUrl: aZnUrl forDoi: aDoi ]
		ifFalse: [ aZnUrl ]
]

{ #category : #accessing }
ZoaLoader class >> loaderFor: aString [
	| loaders |
	loaders := ZoaLoader allSubclasses select: [ :s | s loads: aString ].
	loaders
		ifEmpty: [ self error: (' No loader detected for {1}' format: {aString}) ].
	^ loaders first
]

{ #category : #accessing }
ZoaLoader class >> publisher [

	^ self subclassResponsibility
]

{ #category : #settings }
ZoaLoader >> addTo: anArticle authorFirstNamed: firstname lastName: lastname id: userId affiliations: affiliations [

	| author articleRef |
	author := ZoaAuthor new.
	author name: firstname.
	author lastname: lastname.
	author addId: userId.
	author := zoa findAuthorByExampleOrStore: author.

	anArticle authorsReferences
		detect: [ :a | author ids includesAny: a authorIds ]
		ifFound: [ :ref | affiliations do: [ :a | ref addAffiliation: a ] ]
		ifNone: [ 
			articleRef := ZoaArticleAuthorReference new.
			articleRef affiliation: affiliations.
			articleRef authorIds: author ids.
			author addArticle: articleRef.
			articleRef articleReference: (ZoaArticleReference new
					 reference: anArticle doi;
					 title: anArticle title;
					 yourself).
			anArticle addAuthorReference: articleRef.
			zoa saveAuthor: author.
			articleRef ]
]

{ #category : #'as yet unclassified' }
ZoaLoader >> ensureDoiOn: aDocument id: anId [
	aDocument doi
		ifNil: [ aDocument doi: self class name , '/' , anId asString ]
		ifNotNil: [ (aDocument doi indexOfSubCollection: 'doi.org') > 0
				ifTrue:
					[ aDocument doi: ('/' join: (aDocument doi asZnUrl segments last: 2)) ] ]
]

{ #category : #'as yet unclassified' }
ZoaLoader >> loadBibtex: aContent into: document [
	| stream lines |
	stream := ((aContent readStream upToEnd
		copyReplaceAll: '<br>'
		with: '') copyReplaceAll: ' =' with: '=') readStream.
	document kind: (stream upToAll: '{').
	lines := ((((aContent contents copyReplaceAll: '<br>' with: '')
		copyReplaceAll: '{'
		with: '') copyReplaceAll: '}' with: '') copyReplaceAll: '"' with: '')
		lines select: [ :l | l includes: $= ] thenCollect: #trim.
	lines
		do: [ :p | 
			| pair |
			pair := '=' split: p.
			self
				perform:
					('set{1}:into:'
						format:
							{('' join: (('_' split: (pair at: 1) trimBoth) collect: #capitalized))})
						asSymbol
				withArguments:
					{(pair at: 2).
					document} ]
]

{ #category : #'as yet unclassified' }
ZoaLoader >> loadDocument: anId [ 
	 self subclassResponsibility 
]

{ #category : #settings }
ZoaLoader >> loadUsingResearchGateReferencesTo: anArticle [
 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> sanitizeSymbol: var [

	^ ''
		join:
			(([:c| c isSeparator or: [ { $. . $, . $- } includes: c  ] ]
				split:
					((var copyReplaceAll: 'citation' with: '')
						copyReplaceAll: ':'
						with: '')) collect: #capitalized)
]

{ #category : #setting }
ZoaLoader >> setAbstract: aString into: aZoaDocument [ 
	aZoaDocument abstract: aString
]

{ #category : #initialization }
ZoaLoader >> setAbstractHtmlUrl: aString into: aZoaArticle [ 
	aZoaArticle data at:#AbstractUrl put: aString 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setAccessed: aCollection into: aZoaDocument [ 
	" Date when the article information was accessed "
	
]

{ #category : #accessing }
ZoaLoader >> setArxivId: aString into: aZoaDocument [ 
	aZoaDocument arxivId: aString
]

{ #category : #initialization }
ZoaLoader >> setBookTitle: aString into: aZoaArticle [ 
	aZoaArticle booktitle: aString
]

{ #category : #accessing }
ZoaLoader >> setBooktitle: aString into: aZoaDocument [ 
	aZoaDocument booktitle: aString.
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setCallNumber: aString into: aZoaDocument [

	self assert: aZoaDocument doi = aString
]

{ #category : #settings }
ZoaLoader >> setConference: aString into: aZoaDocument [ 
	aZoaDocument conference: aString 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setDOI: aString into: aZoaDocument [ 
	self setDoi: aString into: aZoaDocument
]

{ #category : #accessing }
ZoaLoader >> setDate: aString into: aZoaDocument [

	| date |
	date := aString isString
		        ifTrue: [ 
			        [ Date fromString: aString ]
				        on: Error
				        do: [ [DateAndTime fuzzyReadFrom: aString readStream]
							on: Error do: [ aString ] ] ]
		        ifFalse: [ aString ].
	aZoaDocument date: date
]

{ #category : #accessing }
ZoaLoader >> setDoi: aString into: aZoaDocument [
	aZoaDocument doi: (aString copyReplaceAll: ',' with: '')
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setEventPlace: aString into: aZoaDocument [

	aZoaDocument data at: #EventCity put: aString
]

{ #category : #initialization }
ZoaLoader >> setFirstpage: aString into: aZoaArticle [

	aZoaArticle pages: { aString trimBoth asNumber }
]

{ #category : #initialization }
ZoaLoader >> setFulltextHtmlUrl: aString into: aZoaArticle [ 
	" This is the link. Is setted up before "
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setISBN: aString into: aZoaDocument [
	aZoaDocument isbn: aString
]

{ #category : #accessing }
ZoaLoader >> setISSN: aString into: aZoaDocument [
	(aString copyReplaceAll: ',' with: '')
		ifNotEmpty: [ :v | aZoaDocument issn: aString ]
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setId: aString into: aZoaDocument [ 
	self setDoi: aString into: aZoaDocument 
]

{ #category : #accessing }
ZoaLoader >> setIsbn: aString into: aZoaDocument [ 
	aZoaDocument isbn: aString
]

{ #category : #accessing }
ZoaLoader >> setIssn: aString into: aZoaDocument [ 
	^ self setISSN: aString into: aZoaDocument 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setIssue: aString into: aZoaArticle [ 
	aZoaArticle issue: aString 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setIssued: aCollection into: aZoaDocument [
	| date  all |
	
	date := { 0 .1 .1}.
	all := (aCollection at: 'date-parts') first.
	all doWithIndex: [ :each : id  | date at: id put: each ].
	self
		setDate: (Date year: date first month: date second day: date third) yyyymmdd
		into: aZoaDocument
]

{ #category : #accessing }
ZoaLoader >> setJournal:aString into: aZoaDocument [
	aZoaDocument journal: aString
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setJournalTitle:aString into: aZoaArticle [
	self setJournal: aString into: aZoaArticle
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setJsonData: aDictionary into: aZoaArticle [

	aDictionary keysAndValuesDo: [ :k :v | 
		| selector |
		v ifNotNil: [
		selector := ('set{1}:into:' format: { k capitalized }) asSymbol.
		(self respondsTo: selector)
			ifTrue: [ 
				self perform: selector withArguments: { 
						v.
						aZoaArticle } ]
			ifFalse: [ aZoaArticle data at: k put: v ]] ]
]

{ #category : #keywords }
ZoaLoader >> setKeywords: anArrayOfkeywords into: anArticle [

	|  keywords |
	keywords := anArrayOfkeywords collect: [ :k | 
		            ZoaTag new
			            name: k;
			            yourself ].
	anArticle keywords: keywords
]

{ #category : #initialization }
ZoaLoader >> setLanguage: aString into: aZoaArticle [ 
	aZoaArticle data at:#Language put: aString 
]

{ #category : #initialization }
ZoaLoader >> setLastpage: aString into: aZoaArticle [

	self setFirstpage: aString into: aZoaArticle
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setMonth: aString into: aZoaDocument [
	| current monthNumber |
	monthNumber := ((aString copyReplaceAll: ',' with: '')
		copyReplaceAll: '.'
		with: '') trimBoth.
	monthNumber := monthNumber isAllDigits
		ifTrue: [ monthNumber asInteger ]
		ifFalse: [ Month indexOfMonth: monthNumber ].
	current := aZoaDocument date ifNotNil: [ :d | d ] ifNil: [ Date new ].
	aZoaDocument
		date: (Date year: current year month: monthNumber day: current day)
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setNote: aString into: aZoaDocument [
	aZoaDocument note: aString
]

{ #category : #accessing }
ZoaLoader >> setNumber: aString into: aZoaDocument [

	(aString select: [ :c | c isDigit ]) ifNotEmpty: [ :v | 
		aZoaDocument data at: #Number put: v trimBoth asNumber ]
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setNumberOfPages: aString into: aZoaArticle [

	aZoaArticle data at: #NumberOfPages put: aString
]

{ #category : #setting }
ZoaLoader >> setOnlineDate: aString into: aZoaDocument [ 
	aZoaDocument date: (aString ifEmpty: [nil ] ifNotEmpty: [ aString asDate ])
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setOriginalDate: aCollection into: aZoaDocument [ 
	self setIssued: aCollection into: aZoaDocument 
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setPage: aString into: aZoaDocument [ 
	self setPages: aString into: aZoaDocument 
]

{ #category : #accessing }
ZoaLoader >> setPages: aString into: aZoaDocument [
	aZoaDocument
		pages:
			(('-' split: (aString copyReplaceAll: ',' with: '') trimBoth )
				select: #isNotEmpty
				thenCollect: [ : v | v trimBoth asNumber])
]

{ #category : #initialization }
ZoaLoader >> setPublicationDate: aString into: aZoaArticle [

	self setDate: aString into: aZoaArticle
]

{ #category : #setting }
ZoaLoader >> setPublisher: aString into: aZoaDocument [ 
	aZoaDocument publisher: aString
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setPublisherPlace: aString into: aZoaDocument [

	aZoaDocument data at:#PublisherCity put: aString
]

{ #category : #accessing }
ZoaLoader >> setTitle: aString into: aZoaDocument [ 
	aZoaDocument title: aString
]

{ #category : #setting }
ZoaLoader >> setTwittersite: aString into: aZoaDocument [ 
  " Nothing to do"
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setType: aString into: aZoaDocument [ 
	aZoaDocument type: aString
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setURL: aString into: aZoaDocument [
	aZoaDocument link: aString asZnUrl
]

{ #category : #'as yet unclassified' }
ZoaLoader >> setUrl: aString into: aZoaArticle [ 
	self setURL: aString into: aZoaArticle 
]

{ #category : #settings }
ZoaLoader >> setVolume: aString into: aZoaDocument [
	(aString copyReplaceAll: ',' with: '')
		ifNotEmpty: [ :v | aZoaDocument volume: v trimBoth asNumber ]
]

{ #category : #settings }
ZoaLoader >> setYear: aString into: aZoaDocument [
	| current |
	current := aZoaDocument date ifNotNil: [ :d | d ] ifNil: [ Date new ].
	aZoaDocument
		date:
			(Date
				year: aString trimBoth asNumber
				month: current monthIndex
				day: current day)
]

{ #category : #'as yet unclassified' }
ZoaLoader >> zoa [

	^ zoa
]

{ #category : #accessing }
ZoaLoader >> zoa: aZoa [ 
	zoa := aZoa
]
