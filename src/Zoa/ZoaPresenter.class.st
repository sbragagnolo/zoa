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
		author openDialogWithSpec okAction: [ author pushChanges ] ].
	^ widget
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
ZoaPresenter >> zoa: aZoa [ 
	zoa := aZoa
]
