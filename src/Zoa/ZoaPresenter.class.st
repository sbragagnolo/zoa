Class {
	#name : #ZoaPresenter,
	#superclass : #SpPresenter,
	#category : #'Zoa-UI'
}

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
