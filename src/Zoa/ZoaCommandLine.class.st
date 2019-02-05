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
ZoaCommandLine class >> browseArticle [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'browse')
		description: '(Web)Browses the PDF of all the matching articles. if it is';
		add: ClapFlag forHelp;
		add: ((ClapNamedParameter withName: 'fd') description: 'Filters by Doi');
		add: ((ClapNamedParameter withName: 'ft') description: 'Filters by Title');
		add: ((ClapNamedParameter withName: 'fct') description: 'Filters by Cite');
		add:
			((ClapNamedParameter withName: 'fkw')
				description: 'Filters by Keywords');
		add: ((ClapNamedParameter withName: 'ftag') description: 'Filters by Tags');
		add:
			((ClapNamedParameter withName: 'fabs')
				description: 'Filters by abstract');
		add:
			((ClapNamedParameter withName: 'fbr') description: 'Filters by briefs');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) browseArticle ]
]

{ #category : #accessing }
ZoaCommandLine class >> cite [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'cite')
		description: 'Sets a cite on an article ';
		add: ClapFlag forHelp;
		add:
			((ClapPositional withName: 'doi')
				description: 'Doi find for the brief');
		add: ((ClapPositional withName: 'cite') description: 'Citation');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) cite ]
]

{ #category : #accessing }
ZoaCommandLine class >> fetch [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

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
ZoaCommandLine class >> getPdf [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'getpdf')
		description: 'Downloads the PDF of all the matching articles. if it is';
		add: ClapFlag forHelp;
		add: ((ClapNamedParameter withName: 'fd') description: 'Filters by Doi');
		add: ((ClapNamedParameter withName: 'ft') description: 'Filters by Title');
		add: ((ClapNamedParameter withName: 'fct') description: 'Filters by Cite');
		add:
			((ClapNamedParameter withName: 'fkw')
				description: 'Filters by Keywords');
		add: ((ClapNamedParameter withName: 'ftag') description: 'Filters by Tags');
		add:
			((ClapNamedParameter withName: 'fabs')
				description: 'Filters by abstract');
		add:
			((ClapNamedParameter withName: 'fbr') description: 'Filters by briefs');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) getPdf ]
]

{ #category : #accessing }
ZoaCommandLine class >> list [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'list')
		description: 'List available entries';
		add: ClapFlag forHelp;
		add: ((ClapNamedParameter withName: 'fd') description: 'Filters by Doi');
		add: ((ClapNamedParameter withName: 'ft') description: 'Filters by title');
		add: ((ClapNamedParameter withName: 'fct') description: 'Filters by Cite');
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
		add: ((ClapFlag withName: 'tag') description: 'Shows tags');
		add: ((ClapFlag withName: 'ct') description: 'Shows cite');
		add: ((ClapFlag withName: 'kw') description: 'Shows keywords');
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
ZoaCommandLine class >> read [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'read')
		description: 'Open the PDF of all the matching articles. if it is';
		add: ClapFlag forHelp;
		add: ((ClapNamedParameter withName: 'fd') description: 'Filters by Doi');
		add: ((ClapNamedParameter withName: 'ft') description: 'Filters by Title');
		add: ((ClapNamedParameter withName: 'fct') description: 'Filters by Cite');
		add:
			((ClapNamedParameter withName: 'fkw')
				description: 'Filters by Keywords');
		add: ((ClapNamedParameter withName: 'ftag') description: 'Filters by Tags');
		add:
			((ClapNamedParameter withName: 'fabs')
				description: 'Filters by abstract');
		add:
			((ClapNamedParameter withName: 'fbr') description: 'Filters by briefs');
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) read ]
]

{ #category : #accessing }
ZoaCommandLine class >> submit [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'submit')
		description:
			'it executes git add .; git commit -m ":neesage" ; git pull; push. Super naive " ';
		add: ClapFlag forHelp;
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ].
			(self with: args) submit ]
]

{ #category : #accessing }
ZoaCommandLine class >> tagscommand [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	^ (ClapCommand withName: 'tag')
		description: 'Adds or remove a tag from a document ';
		add: ClapFlag forHelp;
		add: ((ClapPositional withName: 'doi') description: 'Doi find for the tag');
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
ZoaCommandLine class >> zoa [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'zoa')
		description: 'Zoa ';
		add: ClapFlag forHelp;
		add: self bibtex;
		add: self brief;
		add: self browseArticle;
		add: self cite;
		add: self fetch;
		add: self getPdf;
		add: self list;
		add: self read;
		add: self tagscommand;
		add: self submit;
		meaning: [ :args | 
			args
				atName: 'help'
				ifFound: [ :help | 
					help
						value;
						exitSuccess ] ]
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

{ #category : #accessing }
ZoaCommandLine >> browseArticle [
	arguments validateAll.
	self browseArticleOn: self outStream
]

{ #category : #accessing }
ZoaCommandLine >> browseArticleOn: aStream [
	| all zoa |
	all := self findWithFilters.
	zoa := Zoa new.
	all do: [ :doc | zoa browse: doc ]
]

{ #category : #brief }
ZoaCommandLine >> cite [
	arguments validateAll. 
	self citeOn: self outStream .
]

{ #category : #brief }
ZoaCommandLine >> citeOn: aStream [
	| zoa document |
	zoa := Zoa new.
	(self argumentAt: #doi) isEmptyOrNil
		ifTrue: [ self error: ' DOI is a compulsory argument' ].
	document := zoa findByDoi: (self argumentAt: #doi).
	document cite: (self argumentAt: #cite).
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
	^ {
	('--fct' -> #cite).
	('--ft' -> #title).
	('--fd' -> #doi).
	('--fkw' -> #keywords).
	('--ftag' -> #tags).
	('--fabs' -> #abstract).
	('--fbr' -> #briefs)} asDictionary
]

{ #category : #listing }
ZoaCommandLine >> findWithFilters [
	| filters |
	filters := arguments namedParameters collect: #value.
	^ filters
		inject: Zoa new findAll
		into: [ :acc :each | self filter: acc with: each ]
]

{ #category : #accessing }
ZoaCommandLine >> getPdf [
	arguments validateAll.
	self getPdfOn: self outStream
]

{ #category : #accessing }
ZoaCommandLine >> getPdfOn: aStream [
	| all zoa |
	all := self findWithFilters.
	zoa := Zoa new.
	all
		do: [ :doc | 
			[ zoa getPdf: doc ]
				on: Error
				do: [ :e | 
					aStream
						nextPutAll: ' Error on doi: ';
						nextPutAll: doc doi;
						nextPutAll: ' ';
						nextPutAll: e messageText;
						nextPutAll: String lf ] ]
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
	|  projection all |
	all := self findWithFilters. 
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
	('--ct' -> #cite).
	('--a' -> #abstract).
	('--d' -> #doi).
	('--b' -> #briefs).
	('--kw' -> #arrayKeywords).
	('--tag' -> #arrayTags)} asDictionary
]

{ #category : #accessing }
ZoaCommandLine >> read [
	arguments validateAll.
	self readOn: self outStream
]

{ #category : #accessing }
ZoaCommandLine >> readOn: aStream [
	| all zoa |
	all := self findWithFilters.
	zoa := Zoa new.
	zoa readAll: all
]

{ #category : #accessing }
ZoaCommandLine >> setArguments: args [
	arguments := args
]

{ #category : #brief }
ZoaCommandLine >> submit [
	Zoa new submit.
	self outStream
		nextPutAll: ' submitted ';
		nextPutAll: String lf
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
	('--kw' -> 'Keywords').
	('--ct' -> 'Cite')} asDictionary.
	^ aCollection collect: [ :t | titles at: t ]
]
