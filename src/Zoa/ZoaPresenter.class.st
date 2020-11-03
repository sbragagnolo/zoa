Class {
	#name : #ZoaPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'zoa'
	],
	#category : #'Zoa-UI'
}

{ #category : #'instance creation' }
ZoaPresenter class >> basicNew [

	^ super basicNew
		  zoa: Zoa current;
		  yourself
]

{ #category : #initialization }
ZoaPresenter >> newAuthorList [

	| widget |
	widget := self instantiate: ZoaNamedObjectsWidget.
	widget whenActivatedDo: [ :selection | 
		| author |
		author := self instantiate: ZoaAuthorWidget.
		author author: selection selectedItem.
		author
			okAction: [ author pushChanges ];
			title: selection selectedItem fullName;
			openModalWithSpec ].
	^ widget
]

{ #category : #initialization }
ZoaPresenter >> newBriefsList [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a order < b order ];
		addColumn:
			((SpStringTableColumn title: '#' evaluated: [ :item | item order ])
				 width: 30;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Name'
				  evaluated: [ :item | item name ])
				 width: 100;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Content'
				  evaluated: [ :item | item text readStream next: 50 ])
				 width: 100;
				 yourself);
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | 
		self openBrief: selection selectedItem ];
		beResizable.
	^ table
]

{ #category : #initialization }
ZoaPresenter >> newEditionArea [

	^ self instantiate: SpComponentListPresenter
]

{ #category : #initialization }
ZoaPresenter >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #initialization }
ZoaPresenter >> newStackedComponentWith: anArray [

	| component |
	component := self instantiate: SpDynamicPresenter.
	component layout: SpBoxLayout newVertical.

	anArray do: [ :a | 
		component layout add: a.
		a owner: component ].
	^ component
]

{ #category : #initialization }
ZoaPresenter >> newTagsList [

	| widget |
	widget := self instantiate: ZoaNamedObjectsWidget.
	widget addNewItemRoutine: [ 
		| name |
		name := UIManager default request: 'Enter tag name'.
		name ifNotNil: [ 
			ZoaTag new
				name: name;
				yourself ] ].
	^ widget
]

{ #category : #initialization }
ZoaPresenter >> openBrief: aBrief [

	((self instantiate: ZoaBriefWidget)
		 brief: aBrief;
		 openWithSpec)
		extent: 1143.0 @ 424.0;
		title: aBrief name
]

{ #category : #initialization }
ZoaPresenter >> zoa: aZoa [ 
	zoa := aZoa
]
