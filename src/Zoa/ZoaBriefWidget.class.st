"
It shows a brief with tags and some nice data.
"
Class {
	#name : #ZoaBriefWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#brief => SpObservableSlot',
		'#nameLabel',
		'#text',
		'#tags',
		'#toolBar',
		'#actions',
		'#includeInText',
		'#onSave',
		'#onDelete'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaBriefWidget class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar height: self toolbarHeight;
		add:
			(SpPanedLayout newHorizontal
				add: #text;
				add: #tags;
				position: 90 percent ;
				yourself)
			withConstraints: [ :constraints | 
				constraints
					expand: true;
					fill: true;
					padding: 20;
					height: 300 ];
		add: #actions height: self toolbarHeight;
		yourself
]

{ #category : #'update and set' }
ZoaBriefWidget >> brief: aBrief [
	brief := aBrief
]

{ #category : #actions }
ZoaBriefWidget >> deleteBrief [
	onDelete ifNotNil: [ onDelete cull: brief ].
]

{ #category : #initialization }
ZoaBriefWidget >> initialize [
	super initialize.
]

{ #category : #accessing }
ZoaBriefWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #brief whenChangedDo: [ self updateBrief ]
]

{ #category : #initialization }
ZoaBriefWidget >> initializeToolbar [

	toolBar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #smallSave);
			 action: [ self saveBrief ] yourself).
	toolBar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #smallDelete);
			 action: [ self deleteBrief ] yourself)
]

{ #category : #initialization }
ZoaBriefWidget >> initializeWidgets [

	nameLabel := self newLabel.
	toolBar := self newToolbar.
	self initializeToolbar.

	includeInText := self newButton.
	includeInText action: [ self toggleIncludeText ].

	text := self newText.
	text whenEditableChangedDo: [ self saveBrief ].
	tags := self newTagsList.
	tags onDelete: [ :t | brief tags remove: t ].
	tags onAdd: [ :t | brief tags add: t ].
	actions := self newActionBar.
	actions add: includeInText
]

{ #category : #'data query' }
ZoaBriefWidget >> nameLabel [
	^ nameLabel
]

{ #category : #accessors }
ZoaBriefWidget >> onDelete: aBlock [
	onDelete := aBlock
]

{ #category : #accessors }
ZoaBriefWidget >> onSave: aBlock [
	onSave := aBlock
]

{ #category : #actions }
ZoaBriefWidget >> saveBrief [
	brief text: text text. 
	
	onSave ifNotNil: [ onSave cull: brief ].
]

{ #category : #actions }
ZoaBriefWidget >> toggleIncludeText [
	brief toggleIncludeInText.
	self updateBrief.
]

{ #category : #'update and set' }
ZoaBriefWidget >> updateBrief [
	nameLabel label: brief name.
	text text: brief text.
	tags items: brief tags.
	includeInText
		label:
			(brief includeInText
				ifTrue: [ 'Exclude from text' ]
				ifFalse: [ 'Include in text' ])
]
