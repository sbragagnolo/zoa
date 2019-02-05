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
ZoaCommandLine class >> fetch [
	"The usual Hello-World example, demonstrating a Clap command with a couple options."

	<commandline>
	^ (ClapCommand withName: 'fetch')
		description:
			'Fetch an article  (Only works with ACM, IEEE, ArxIv and ResearchGate articles) ';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'url') description: 'Fetches by Url');
		add: ((ClapFlag withName: 'doi') description: 'Fetches by Doi');
		add: ((ClapPositional withName: 'value') description: 'Shows briefs');
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
ZoaCommandLine class >> filter: aName description: description [
	^ (ClapCommand withName: aName)
		description: description;
		add: (ClapPositional withName: 'filter')
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
ZoaCommandLine class >> load [
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

{ #category : #filtering }
ZoaCommandLine >> filter: aCollection with: aFilterconf [
	^ aCollection
		select: [ :doc | self corresponds: doc to: aFilterconf ]
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

{ #category : #accessing }
ZoaCommandLine >> setArguments: args [
	arguments := args
]

{ #category : #accessing }
ZoaCommandLine >> titleFor: aCollection [
	| titles |
	titles := {('--t' -> 'Title').
	('--a' -> 'Abstract').
	('--d' -> 'Doi').
	('--b' -> 'Brief')} asDictionary.
	^ aCollection collect: [ :t | titles at: t ]
]
