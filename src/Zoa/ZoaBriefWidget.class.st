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
		'#onDelete',
		'#name',
		'#addedTags',
		'#removedTags',
		'#ok',
		'#cancel',
		'#window',
		'#order'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaBriefWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpPanedLayout newHorizontal
				   add: #name;
				   add: #order;
				   position: 90 percent;
				   yourself);
		  add: (SpBoxLayout newHorizontal
				   add: #text;
				   add: #tags  width: 110 ;

				   yourself)
		  withConstraints: [ :constraints | 
			  constraints
				  expand: true;
				  fill: true;
				  padding: 20; height: 500 ];
		  add: (SpBoxLayout newHorizontal
				   add: #ok width: 150;
				   add: #cancel width: 150;
				   yourself)
		  withConstraints: [ :constraints | 
			  constraints
				  expand: false;
				  fill: false;
				  padding: 70 percent ];
		  yourself
]

{ #category : #initialization }
ZoaBriefWidget >> addTag: aTag [ 
	addedTags add: aTag.
]

{ #category : #'update and set' }
ZoaBriefWidget >> brief: aBrief [
	brief := aBrief.
	addedTags removeAll. 
	removedTags removeAll. 
]

{ #category : #initialization }
ZoaBriefWidget >> initialize [

	super initialize.
	addedTags := OrderedCollection new.
	removedTags := OrderedCollection new
]

{ #category : #accessing }
ZoaBriefWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #brief whenChangedDo: [ self updateBrief ]
]

{ #category : #initialization }
ZoaBriefWidget >> initializeToolbar [


	includeInText :=  (self newToolbarToggleButton
			 action: [ self toggleIncludeText ];
			 yourself).
	toolBar addItemLeft:includeInText
]

{ #category : #initialization }
ZoaBriefWidget >> initializeWidgets [

	toolBar := self newToolbar.
	self initializeToolbar.

	name := self newTextInput.
	order := self newNumberInput. 
	text := self newText.
	text autoAccept: true.
	tags := self newTagsList.
	tags onDelete: [ :t | self removeTag: t ].
	tags onAdd: [ :t | self addTag: t ].
	ok := self newButton.
	ok label: 'Accept'.
	ok action: [ 
		self pushChanges.
		window close ].
	cancel := self newButton.
	cancel label: 'Cancel'.
	cancel action: [ window close ]
]

{ #category : #accessing }
ZoaBriefWidget >> initializeWindow: aWindow [
	super initializeWindow: aWindow.
	window := aWindow.
]

{ #category : #'data query' }
ZoaBriefWidget >> nameLabel [
	^ nameLabel
]

{ #category : #actions }
ZoaBriefWidget >> pushChanges [
	brief order: order text asInteger. 
	brief text: text text.
	brief name: name text.
	addedTags do: [ :t | brief addTag: t ].
	removedTags do: [ :t | brief removeTag: t ].
	
]

{ #category : #initialization }
ZoaBriefWidget >> removeTag: aTag [

	(addedTags includes: aTag)
		ifTrue: [ addedTags remove: aTag ]
		ifFalse: [ removedTags add: aTag ]
]

{ #category : #actions }
ZoaBriefWidget >> toggleIncludeText [
	brief toggleIncludeInText.
	self updateBrief.
]

{ #category : #'update and set' }
ZoaBriefWidget >> updateBrief [

	brief ifNil: [ 
		name text: ''.
		text text: ''.
		tags items: {  }.
		^ self ].
	name text: brief name.
	text text: brief text.
	order number: brief order. 
	tags items:
		(brief tags , addedTags reject: [ :t | removedTags includes: t ]).
	includeInText label: (brief includeInText
			 ifTrue: [ 'Exclude' ]
			 ifFalse: [ 'Include' ]).
	
]
