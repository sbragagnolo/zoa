"
Author brief
"
Class {
	#name : #ZoaAuthorWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#author => SpObservableSlot',
		'#firstName',
		'#lastName',
		'#ids',
		'#firstNameLabel',
		'#lastNameLabel',
		'#idLabel',
		'#authority',
		'#identifier',
		'#set',
		'#authorityLabel',
		'#identifierLabel',
		'#idModification',
		'#add',
		'#newId'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaAuthorWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #firstNameLabel width: 30;
		  add: #firstName width: 30;
		  add: #lastNameLabel width: 30;
		  add: #lastName width: 30;
		  add: #idLabel width: 30;
		  add: (SpBoxLayout newHorizontal
				   add: #ids;
				   add: (SpBoxLayout newVertical
						    add: #authorityLabel width: 30;
						    add: #authority width: 30;
						    add: #identifierLabel width: 30;
						    add: #identifier width: 30;
						    add: (SpBoxLayout newHorizontal
								     add: #set;
								     add: #add) yourself);
				   yourself);
		  yourself
]

{ #category : #specs }
ZoaAuthorWidget class >> example [
	<example>
	self new
		author:
			(ZoaAuthor new
				name: 'Santiago';
				lastname: 'Bragagnolo';
				yourself);
		openWithSpec
]

{ #category : #initialization }
ZoaAuthorWidget >> author: anAuthor [
	author := anAuthor
]

{ #category : #accessing }
ZoaAuthorWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #author whenChangedDo: [ self updateAuthor ]
]

{ #category : #initialization }
ZoaAuthorWidget >> initializeWidgets [

	firstName := self newTextInput.
	firstNameLabel := self newLabel.
	firstNameLabel label: 'First Name'.
	lastNameLabel := self newLabel.
	lastNameLabel label: 'Last Name'.
	idLabel := self newLabel.
	idLabel label: 'Identifiers'.
	lastName := self newTextInput.
	ids := self newDataTable.
	authorityLabel := self newLabel.
	authorityLabel label: 'Authority'.
	identifierLabel := self newLabel.
	identifierLabel label: 'Identifier'.
	authority := self newTextInput.
	identifier := self newTextInput.
	set := self newButton.
	set label: 'Modify'.
	set action: [ self saveIdModification ].
	add := self newButton.
	add label: 'New'.
	add action: [ self saveNewId ].

	newId := OrderedCollection new.
	idModification := Dictionary new
]

{ #category : #initialization }
ZoaAuthorWidget >> newDataTable [

	^ self newList
		  display: [ :id | id authority , ' - ' , id id ];
		  activateOnSingleClick;
		  whenActivatedDo: [ :selection | 
			  authority text: selection selectedItem authority.
			  identifier text: selection selectedItem id ];
		  yourself
]

{ #category : #initialization }
ZoaAuthorWidget >> pushChanges [

	author name: firstName text.
	author lastname: lastName text.
	newId do: [ :id | author addId: id ].
	idModification keysAndValuesDo: [ :original :modification | 
		original authority: modification authority.
		original id: modification id ].
	zoa saveAuthor: author. 
]

{ #category : #initialization }
ZoaAuthorWidget >> saveIdModification [

	| modifing |
	ids selectedItem ifNil: [ ^ self ].

	(UIManager default confirm:
		 'Modify an ID of an author can lead to leak of articles. Please ensure you know what you are doing. Do you want to continue? ') 
		ifFalse: [ ^ self ].
	modifing := idModification
		            keyAtValue: ids selectedItem
		            ifAbsent: [ ids selectedItem ].

	idModification
		at: modifing
		put: (ZoaAuthorID authority: authority text id: identifier text).
	self updateAuthor
]

{ #category : #initialization }
ZoaAuthorWidget >> saveNewId [

	newId add:
		(ZoaAuthorID authority: authority text id: identifier text).
	self updateAuthor
]

{ #category : #accessing }
ZoaAuthorWidget >> updateAuthor [

	firstName text: author firstname.
	lastName text: author lastname.
	ids items: (author ids asOrderedCollection , newId collect: [ :id | 
			 idModification at: id ifAbsent: [ id ] ])
]
