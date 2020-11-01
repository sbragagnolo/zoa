Class {
	#name : #ZoaNamedObjectsWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#items => SpObservableSlot',
		'#table',
		'#bar',
		'#onAdd',
		'#onDelete',
		'#addNewItemRoutine'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaNamedObjectsWidget class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #bar height: self toolbarHeight;
		add: #table;
		yourself
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> addItem [

	| item |
	item := addNewItemRoutine value.
	item ifNotNil: [ 
		items add: item.
		onAdd value: item.
		self updateItems ]
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> addNewItemRoutine: aBlock [
	addNewItemRoutine := aBlock
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> initialize [
	super initialize.
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #items whenChangedDo: [ self updateItems ]
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> initializeWidgets [
	onAdd := [ :v |  ].
	onDelete := onAdd .
	table := self newTable
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
	table activateOnDoubleClick .

	bar := self newToolbar.
	bar
		addItemLeft:
			(self newToolbarButton 
				icon: (Smalltalk ui icons iconNamed: #add);
				action: [ self addItem ] yourself);
		addItemLeft:
			(self newToolbarButton 
				icon: (Smalltalk ui icons iconNamed: #changeRemove);
				action: [ self removeItem ] yourself)
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> items: aCollectionOfTags [
	items:= aCollectionOfTags asOrderedCollection 
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> onAdd: aBlock [
	onAdd := aBlock
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> onDelete: aBlock [
	onDelete := aBlock
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> removeItem [

	| item |
	item := table selection selectedItem.
	items remove: item.
	onDelete value: item.
	self updateItems
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> updateItems [
	table items: items
]

{ #category : #initialization }
ZoaNamedObjectsWidget >> whenActivatedDo: aBlock [
	table whenActivatedDo: aBlock
]
