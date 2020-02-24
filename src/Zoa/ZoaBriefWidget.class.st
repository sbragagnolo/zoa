"
It shows a brief with tags and some nice data.
"
Class {
	#name : #ZoaBriefWidget,
	#superclass : #SpPresenter,
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
				position: 850;
				yourself)
			withConstraints: [ :constraints | 
				constraints
					expand: true;
					fill: true;
					padding: 20;
					height: 200 ];
		add: #actions height: self toolbarHeight;
		yourself
]

{ #category : #initialization }
ZoaBriefWidget >> brief: aBrief [
	brief := aBrief
]

{ #category : #accessing }
ZoaBriefWidget >> currentTags [
	^ brief tags collect: [ :t | ZoaTagKeywordWidget new tag: t ]
]

{ #category : #initialization }
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
ZoaBriefWidget >> initializeWidgets [
	nameLabel := self newLabel.
	toolBar := self newToolBar.
	toolBar
		addItemLeft:
			(SpToolBarButton new
				icon: (Smalltalk ui icons iconNamed: #smallSave);
				action: [ self saveBrief ] yourself).
	toolBar
		addItemLeft:
			(SpToolBarButton new
				icon: (Smalltalk ui icons iconNamed: #smallDelete);
				action: [ self deleteBrief ] yourself).
	includeInText := self newButton.
	includeInText action: [ self toggleIncludeText ].

	text := self newText.
	text whenTextIsAcceptedDo: [ self saveBrief ].
	tags := self instantiate: ZoaTagsWidget.
	actions := self newActionBar.
	actions add: includeInText
]

{ #category : #accessing }
ZoaBriefWidget >> nameLabel [
	^ nameLabel
]

{ #category : #initialization }
ZoaBriefWidget >> onDelete: aBlock [
	onDelete := aBlock
]

{ #category : #initialization }
ZoaBriefWidget >> onSave: aBlock [
	onSave := aBlock
]

{ #category : #initialization }
ZoaBriefWidget >> saveBrief [
	brief text: text text. 
	
	onSave ifNotNil: [ onSave cull: brief ].
]

{ #category : #initialization }
ZoaBriefWidget >> toggleIncludeText [
	brief toggleIncludeInText.
	self updateBrief.
]

{ #category : #accessing }
ZoaBriefWidget >> updateBrief [
	nameLabel label: brief name.
	text text: brief text.
	tags tags: brief tags.
	includeInText
		label:
			(brief includeInText
				ifTrue: [ 'Exclude from text' ]
				ifFalse: [ 'Include in text' ])
]
