"
I am a simple article dialog made for choosing articles .
"
Class {
	#name : #ZoaArticleDialog,
	#superclass : #ZoaPresenter,
	#instVars : [
		'articles',
		'preview',
		'chosenArticles'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaArticleDialog class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		  position: 40 percent;
		  add: #articles;
		  add: #preview
]

{ #category : #accessing }
ZoaArticleDialog >> chosenArticles [
	^ chosenArticles
]

{ #category : #initialization }
ZoaArticleDialog >> filterArticles: aCollectionOfArticles [

	articles items:
		(articles items reject: [ :a | aCollectionOfArticles includes: a ])
]

{ #category : #initialization }
ZoaArticleDialog >> initializePresenters [
	super initializePresenters. 
	articles items: zoa findAllArticles 
]

{ #category : #initialization }
ZoaArticleDialog >> initializeWidgets [

	super initializeWidgets.
	chosenArticles := OrderedCollection new.

	articles := self newTable.
	preview := self newText.
	articles := self newArticleTableUsing: zoa. 
	
]

{ #category : #initialization }
ZoaArticleDialog >> newArticleTableUsing: aZoa [

	^ self newTable
		  sortingBlock: [ :a :b | a title < b title ];
		  addColumn: ((SpCheckBoxTableColumn
				    title: ' '
				    evaluated: [ :x | chosenArticles includes: x ])
				   onActivation: [ :class | chosenArticles add: class ];
				   onDeactivation: [ :class | chosenArticles remove: class ];
				   width: 20;
				   yourself);
		  addColumn: ((SpStringTableColumn
				    title: 'Date'
				    evaluated: [ :item | item date year asString ])
				   width: 50;
				   beSortable;
				   yourself);
		  addColumn: ((SpStringTableColumn
				    title: 'Author'
				    evaluated: [ :item | item firstAuthorName ])
				   width: 100;
				   beSortable;
				   yourself);
		  addColumn:
			  ((SpStringTableColumn
				    title: 'Title'
				    evaluated: [ :item | item title ])
				   beSortable;
				   yourself);
		  whenSelectionChangedDo: [ :selection | 
			  selection selectedItem ifNotNil: [ :article | 
				  preview text:
					  (MicroDownParser asText: (article microdownBriefUsing: aZoa)) ] ];
		  beResizable
]
