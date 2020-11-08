Class {
	#name : #ZoaQuestionWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'question',
		'idLabel',
		'textLabel',
		'codificationLabel',
		'unitLabel',
		'text',
		'codifications',
		'unit',
		'codification',
		'deleteCodification',
		'acceptCodification',
		'okButton',
		'cancelButton',
		'window',
		'addedCodifications',
		'deletedCodifications'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaQuestionWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #idLabel expand: false;
		  add: #textLabel expand: false;
		  add: #text;
		  add: #codificationLabel expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: #codifications;
				   add: (SpBoxLayout newVertical
						    add: #codification;
						    add: (SpBoxLayout newHorizontal
								     add: #acceptCodification width: 30;
								     add: #deleteCodification width: 30) expand:false ));
		  add: #unitLabel expand: false; 
		  add: #unit  expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: #okButton width:150;
				   add: #cancelButton width:150)
		  expand: false
]

{ #category : #specs }
ZoaQuestionWidget class >> open [

	<example>
	| new |
	new := self new.
	new openWithSpec
		title: 'Review';
		extent: 696@405.
	^ new
]

{ #category : #initialization }
ZoaQuestionWidget >> acceptChanges [
	question text: text text asString . 
	
	question codifications addAll: addedCodifications. 
	question codifications removeAll: deletedCodifications. 
	question unit: unit selectedItem. 

]

{ #category : #initialization }
ZoaQuestionWidget >> acceptNewCodification [
	addedCodifications add: (codification text).
	codification text:''.
	self updateCodifications
]

{ #category : #initialization }
ZoaQuestionWidget >> cancel [ 
	window close 
]

{ #category : #initialization }
ZoaQuestionWidget >> deleteSelectedCodification [

	(addedCodifications includes: codifications selectedItem)
		ifTrue: [ addedCodifications remove: codifications selectedItem ]
		ifFalse: [ deletedCodifications add: codifications selectedItem ].
	self updateCodifications
]

{ #category : #initialization }
ZoaQuestionWidget >> initialize [

	super initialize.
	deletedCodifications := OrderedCollection new.
	addedCodifications := OrderedCollection new
]

{ #category : #initialization }
ZoaQuestionWidget >> initializeLabels [

	idLabel := self newLabel
		           label: 'ID';
		           yourself.
	textLabel := self newLabel
		             label: 'Question';
		             yourself.
	codificationLabel := self newLabel
		                     label: 'Codifications';
		                     yourself.
	unitLabel := self newLabel
		             label: 'Unit';
		             yourself
]

{ #category : #initialization }
ZoaQuestionWidget >> initializeWidgets [

	super initializeWidgets.
	self initializeLabels.
	text := self newText.
	unit := self newDropList.
	unit items: zoa findAllResearchQuestionUnits.
	codifications := self newList.
	codification := self newTextInput.
	deleteCodification := self newButton
		                      icon: (self iconNamed: #delete);
		                      action: [ self deleteSelectedCodification ];
		                      yourself.

	acceptCodification := self newButton
		                      icon: (self iconNamed: #changeAdd);
		                      action: [ self acceptNewCodification ];
		                      yourself.

	okButton := self newButton
		            label: #Accept;
		            action: [ self acceptChanges ];
		            yourself.
	cancelButton := self newButton
		                label: #Cancel;
		                action: [ self cancel ];
		                yourself
]

{ #category : #initialization }
ZoaQuestionWidget >> initializeWindow: aWindow [ 
	super initializeWindow: aWindow .
	window := aWindow 
]

{ #category : #initialization }
ZoaQuestionWidget >> question: aQuestion [ 
	question := aQuestion .
	self updateWidget. 
]

{ #category : #initialization }
ZoaQuestionWidget >> updateCodifications [

	codifications items:
		(addedCodifications , question codifications reject: [ :s | 
			 deletedCodifications includes: s ])
]

{ #category : #initialization }
ZoaQuestionWidget >> updateWidget [

	text text: question text.
	self updateCodifications.
	idLabel label: question id asString.
	unit selectItem: (question unit ifNil: [ #String ])
]
