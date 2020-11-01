Class {
	#name : #ZoaTagsWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#tags => SpObservableSlot',
		'#table',
		'#bar',
		'#onAddTags',
		'#onDeleteTag'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaTagsWidget class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #bar height: self toolbarHeight;
		add: #table;
		yourself
]

{ #category : #initialization }
ZoaTagsWidget >> addTag [
	| name tag |
	name := UIManager default request: 'Enter tag name'.
	name ifNil: [ ^ self ].
	tag := ZoaTag new
		name: name;
		yourself.
	tags add: tag.
	onAddTags value: tag.
	self updateTags.
]

{ #category : #initialization }
ZoaTagsWidget >> initialize [
	super initialize.
]

{ #category : #initialization }
ZoaTagsWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #tags whenChangedDo: [ self updateTags ]
]

{ #category : #initialization }
ZoaTagsWidget >> initializeWidgets [
	onAddTags  := [ :v |  ].
	onDeleteTag :=onAddTags .
	table := self newTable
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
	bar := self newToolbar.
	bar
		addItemLeft:
			(self newToolbarButton 
				icon: (Smalltalk ui icons iconNamed: #add);
				action: [ self addTag ] yourself);
		addItemLeft:
			(self newToolbarButton 
				icon: (Smalltalk ui icons iconNamed: #changeRemove);
				action: [ self removeTag ] yourself)
]

{ #category : #initialization }
ZoaTagsWidget >> onAddTags: aBlock [
	onAddTags := aBlock
]

{ #category : #initialization }
ZoaTagsWidget >> onDeleteTag: aBlock [
	onDeleteTag := aBlock
]

{ #category : #initialization }
ZoaTagsWidget >> removeTag [

	| tag |
	tag := table selection selectedItem.
	tags remove: tag.
	onDeleteTag value: tag.
	self updateTags
]

{ #category : #initialization }
ZoaTagsWidget >> tags [
	^ tags
]

{ #category : #initialization }
ZoaTagsWidget >> tags: aCollectionOfTags [
	tags := aCollectionOfTags asOrderedCollection 
]

{ #category : #initialization }
ZoaTagsWidget >> updateTags [
	table items: tags
]
