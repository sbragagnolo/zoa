Class {
	#name : #ZoaLoader,
	#superclass : #Object,
	#category : #Zoa
}

{ #category : #accessing }
ZoaLoader class >> loaderFor: aString [
	| loaders |
	loaders := ZoaLoader allSubclasses select: [ :s | s loads: aString ].
	loaders
		ifEmpty: [ self error: (' No loader detected for {1}' format: {aString}) ].
	^ loaders first
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

{ #category : #setting }
ZoaLoader >> setAbstract: aString into: aZoaDocument [ 
	aZoaDocument abstract: aString
]

{ #category : #accessing }
ZoaLoader >> setAuthor: aString into: aZoaDocument [
	| extracted |
	extracted := ('§' split: (aString copyReplaceAll: ' and ' with: '§'))
		select: #isNotEmpty.
	aZoaDocument
		authors:
			((aZoaDocument authors ifNil: [ OrderedCollection new ])
				addAll: extracted;
				yourself)
]

{ #category : #accessing }
ZoaLoader >> setAuthors: aString into: aZoaDocument [  
	aZoaDocument authors:( (';' split: aString ) collect:#trimBoth)
]

{ #category : #accessing }
ZoaLoader >> setBooktitle: aString into: aZoaDocument [ 
	aZoaDocument booktitle: aString.
]

{ #category : #settings }
ZoaLoader >> setConference: aString into: aZoaDocument [ 
	aZoaDocument conference: aString 
]

{ #category : #accessing }
ZoaLoader >> setDate: aString into: aZoaDocument [ 
	aZoaDocument date: aString asDate
]

{ #category : #accessing }
ZoaLoader >> setDoi: aString into: aZoaDocument [
	aZoaDocument doi: (aString copyReplaceAll: ',' with: '')
]

{ #category : #accessing }
ZoaLoader >> setISSN: aString into: aZoaDocument [
	(aString copyReplaceAll: ',' with: '')
		ifNotEmpty: [ :v | aZoaDocument issn: aString ]
]

{ #category : #accessing }
ZoaLoader >> setIsbn: aString into: aZoaDocument [ 
	aZoaDocument isbn: aString
]

{ #category : #accessing }
ZoaLoader >> setIssn: aString into: aZoaDocument [ 
	^ self setISSN: aString into: aZoaDocument 
]

{ #category : #accessing }
ZoaLoader >> setJournal: aString into: aZoaDocument [
	aZoaDocument journal: aString
]

{ #category : #keywords }
ZoaLoader >> setKeywords: aString into: aZoaDocument [ 
	aZoaDocument keywords: ((';' split: aString) collect: #trimBoth)
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
	(aString copyReplaceAll: ',' with: '')
		ifNotEmpty: [ :v | aZoaDocument number: v trimBoth asNumber ]
]

{ #category : #setting }
ZoaLoader >> setOnlineDate: aString into: aZoaDocument [ 
	aZoaDocument date: aString asDate 
]

{ #category : #accessing }
ZoaLoader >> setPages: aString into: aZoaDocument [
	aZoaDocument
		pages:
			(('-' split: (aString copyReplaceAll: ',' with: '') trimBoth )
				select: #isNotEmpty
				thenCollect: [ : v | v trimBoth asNumber])
]

{ #category : #setting }
ZoaLoader >> setPublisher: aString into: aZoaDocument [ 
	aZoaDocument publisher: aString
]

{ #category : #accessing }
ZoaLoader >> setTitle: aString into: aZoaDocument [ 
	aZoaDocument title: aString
]

{ #category : #url }
ZoaLoader >> setUrl: aString into: aZoaDocument [ 
	
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
