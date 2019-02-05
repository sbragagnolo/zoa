Class {
	#name : #ZoaCommandLine,
	#superclass : #Object,
	#instVars : [
		'outStream',
		'arguments'
	],
	#category : #Zoa
}

{ #category : #accessing }
ZoaCommandLine class >> bibtex [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'bibtex')
		description: 'Gets the bibtex of a given doi ';
		add: ClapFlag forHelp;
		add: ((ClapPositional withName: 'doi') description: 'Doi find for the tag');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) bibtex ]
]

{ #category : #accessing }
ZoaCommandLine class >> brief [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'brief')
		description: 'Sets a brief on an article ';
		add: ClapFlag forHelp;
		add:
			((ClapNamedParameter withName: 'editor')
				description: 'Command editor to open');
		add:
			((ClapPositional withName: 'doi')
				description: 'Doi find for the brief');
		add:
			((ClapPositional withName: 'brief')
				description: 'Optional parameter wiht the text message');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) brief ]
]

{ #category : #accessing }
ZoaCommandLine class >> fetch [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'fetch')
		description:
			'Fetch an article  (Only works with ACM, IEEE, ArxIv and ResearchGate articles) ';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'url') description: 'Fetches by Url');
		add: ((ClapFlag withName: 'doi') description: 'Fetches by Doi');
		add:
			((ClapPositional withName: 'value')
				description: '[{URL*} | {DOI*}';
				multiple: true;
				yourself);
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) fetch ]
]

{ #category : #accessing }
ZoaCommandLine class >> list [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'list')
		description: 'List available entries';
		add: ClapFlag forHelp;
		add: ((ClapNamedParameter withName: 'fd') description: 'Filters by Doi');
		add: ((ClapNamedParameter withName: 'ft') description: 'Filters by title');
		add:
			((ClapNamedParameter withName: 'fkw')
				description: 'Filters by Keywords');
		add: ((ClapNamedParameter withName: 'ftag') description: 'Filters by Tags');
		add:
			((ClapNamedParameter withName: 'fabs')
				description: 'Filters by abstract');
		add:
			((ClapNamedParameter withName: 'fbr') description: 'Filters by briefs');
		add: ((ClapFlag withName: 't') description: 'Shows title');
		add: ((ClapFlag withName: 'a') description: 'Shows abstract');
		add: ((ClapFlag withName: 'd') description: 'Shows Doi');
		add: ((ClapFlag withName: 'tag') description: 'Shows Doi');
		add: ((ClapFlag withName: 'kw') description: 'Shows Doi');
		add: ((ClapFlag withName: 'b') description: 'Shows briefs');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) list ]
]

{ #category : #accessing }
ZoaCommandLine class >> tagscommand [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'tag')
		description: 'Adds or remove a tag from a document ';
		add: ClapFlag forHelp;
		add:
			((ClapPositional withName: 'doi') description: 'Doi find for the tag');
		add:
			((ClapPositional withName: 'tag')
				multiple: true;
				description: 'One or many tags');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) tag ]
]

{ #category : #'instance creation' }
ZoaCommandLine class >> with: arguments [
	^ self new
		setArguments: arguments;
		yourself
]

{ #category : #accessing }
ZoaCommandLine >> argumentAt: argumentName [
	^ (arguments atName: argumentName) value
]

{ #category : #brief }
ZoaCommandLine >> bibtex [
	arguments validateAll. 
	self bibtexOn: self outStream .
]

{ #category : #brief }
ZoaCommandLine >> bibtexOn: aStream [
	| zoa document |
	zoa := Zoa new.
	(self argumentAt: #doi) isEmptyOrNil
		ifTrue: [ self error: ' DOI is a compulsory argument' ].
	document := zoa findByDoi: (self argumentAt: #doi).
	aStream nextPutAll: document bibtex
]

{ #category : #brief }
ZoaCommandLine >> brief [
	arguments validateAll. 
	self briefOn: self outStream .
]

{ #category : #brief }
ZoaCommandLine >> briefOn: aStream [
	| zoa document |
	zoa := Zoa new.
	(self argumentAt: #doi) isEmptyOrNil
		ifTrue: [ self error: ' DOI is a compulsory argument' ].
	document := zoa findByDoi: (self argumentAt: #doi).
	document
		briefs:
			((arguments atName: #brief) isExplicit
				ifTrue: [ self argumentAt: #brief ]
				ifFalse: [ self launchEditorAndRead ]).
	zoa save: document.
	aStream nextPutAll: 'Successfully saved brief'
]

{ #category : #filtering }
ZoaCommandLine >> corresponds: aZoaDocument to: aClapNamedArgument [
	| values property |
	values := ' ' split: aClapNamedArgument value.
	property := aZoaDocument
		perform: (self filters at: aClapNamedArgument name) asSymbol.
	property := property isString
		ifTrue: [ {property} ]
		ifFalse: [ property ].
	^ property
		anySatisfy: [ :p | 
			(values select: [ :v | p includesSubstring: v caseSensitive: false ])
				size >= (values size * 0.5) ]
]

{ #category : #accessing }
ZoaCommandLine >> fetch [
	arguments validateAll.
	self fetchOn: self outStream
]

{ #category : #accessing }
ZoaCommandLine >> fetchOn: aStream [
	| zoa document |
	zoa := Zoa new.
	[ ((arguments atName: #value) allOccurrencesCollect: #value)
		do: [ :id | 
			document := (self argumentAt: #doi)
				ifTrue: [ zoa saveDoi: id ]
				ifFalse: [ zoa saveUrl: id asUrl ] ].
	aStream
		nextPutAll:
			(' Successfully downloaded {1}:{2}'
				format:
					{document doi.
					document title}).
	aStream nextPut: Character lf ]
		on: Error
		do: [ :e | 
			self
				error:
					(' Error downloading {1}:{2}'
						format:
							{document doi.
							document title}) ]
]

{ #category : #filtering }
ZoaCommandLine >> filter: aCollection with: aFilterconf [
	^ aCollection
		select: [ :doc | self corresponds: doc to: aFilterconf ]
]

{ #category : #accessing }
ZoaCommandLine >> filters [
	^ {('--ft' -> #title).
	('--fd' -> #doi).
	('--fkw' -> #keywords).
	('--ftag' -> #tags).
	('--fabs' -> #abstract).
	('--fbr' -> #briefs)} asDictionary
]

{ #category : #brief }
ZoaCommandLine >> launchEditorAndRead [
	| editor tmp |
	tmp := FileLocator temp / UUID new asString.
	editor := (arguments atName: #editor) isExplicit
		ifTrue: [ (arguments atName: #editor) namedArgument value ]
		ifFalse: [ 'vi' ].
	([ :spec | 
	spec
		command: editor;
		arguments: {tmp fullName} ] asOSTask
		future: TKTNewProcessTaskRunner new) synchronizeTimeout: 48 hours.
	^ tmp asFileReference readStream upToEnd
]

{ #category : #accessing }
ZoaCommandLine >> list [
	arguments validateAll.
	self listOn: self outStream
]

{ #category : #listing }
ZoaCommandLine >> listOn: aStream [
	| filters projection all |
	all := Zoa new findAll.
	filters := arguments namedParameters collect: #value.
	all := filters
		inject: all
		into: [ :acc :each | self filter: acc with: each ].
	projection := arguments flags collect: #word.
	projection ifEmpty: [ projection := {'--t'} ].
	aStream nextPutAll: (' | ' join: (self titleFor: projection)).
	aStream nextPut: Character lf.
	all
		do: [ :each | 
			aStream
				nextPutAll: (' | ' join: (self project: each with: projection));
				cr ]
]

{ #category : #accessing }
ZoaCommandLine >> outStream [
	^ outStream ifNil: [ outStream := VTermOutputDriver on: arguments context stdout ]
]

{ #category : #projecting }
ZoaCommandLine >> project: aZoaDocument with: aCollection [
	^ aCollection collect: [ :p | self projection: p on: aZoaDocument ]
]

{ #category : #projecting }
ZoaCommandLine >> projection: aString on: aZoaDocument [
	^( aZoaDocument perform: (self projections at: aString) asSymbol ) asString
]

{ #category : #accessing }
ZoaCommandLine >> projections [
	^ {('--t' -> #title).
	('--a' -> #abstract).
	('--d' -> #doi).
	('--b' -> #briefs).
	('--kw' -> #arrayKeywords).
	('--tag' -> #arrayTags)} asDictionary
]

{ #category : #accessing }
ZoaCommandLine >> setArguments: args [
	arguments := args
]

{ #category : #brief }
ZoaCommandLine >> tag [
	arguments validateAll. 
	self tagOn: self outStream .
]

{ #category : #brief }
ZoaCommandLine >> tagOn: aStream [
	| zoa document msg |
	zoa := Zoa new.
	(self argumentAt: #doi) isEmptyOrNil
		ifTrue: [ self error: ' DOI is a compulsory argument' ].
	document := zoa findByDoi: (self argumentAt: #doi).
	((arguments atName: #tag) allOccurrencesCollect: #value)
		do: [ :tag | 
			(document tags includes: tag)
				ifTrue: [ msg := 'removed'.
					document tags remove: tag ]
				ifFalse: [ msg := 'added'.
					document tags add: tag ] ].
	zoa save: document.
	aStream nextPutAll: ('Successfully {1} tag' format: {msg})
]

{ #category : #accessing }
ZoaCommandLine >> titleFor: aCollection [
	| titles |
	titles := {('--t' -> 'Title').
	('--a' -> 'Abstract').
	('--d' -> 'Doi').
	('--b' -> 'Brief').
	('--tag' -> 'Tags').
	('--kw' -> 'Keywords')} asDictionary.
	^ aCollection collect: [ :t | titles at: t ]
]
