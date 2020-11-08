"
Article viewer
"
Class {
	#name : #ZoaArticleViewer,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#article => SpObservableSlot',
		'#view',
		'#preview',
		'#metadata',
		'#toolBar',
		'#onArticleReloadClicked',
		'#tabs',
		'#references',
		'#allArticles',
		'#htmlRefs'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaArticleViewer class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolBar height: self toolbarHeight * 1.5;
		  add: (SpBoxLayout newVertical
				   add: #tabs;
				   yourself)
]

{ #category : #specs }
ZoaArticleViewer class >> example [
	<example>
	self new
		article: (Zoa new loadAndSaveArticleDoi: '10.1145/3139903.3139909');
		openWithSpec
]

{ #category : #actions }
ZoaArticleViewer >> addBrief [
	| name |
	name := UIManager default request: 'Brief name'.
	name
		ifNotNil: [ article
				addBrief:
					(ZoaBrief new
						name: name;
						yourself) ].
	self updateArticle 
]

{ #category : #'update and set' }
ZoaArticleViewer >> article: anArticle [
	article := anArticle.
	self updateArticle .
]

{ #category : #actions }
ZoaArticleViewer >> deleteArticle [
	zoa delete: article.
	self inform: 'Deleted from database... '.
	owner updateViewers .
]

{ #category : #actions }
ZoaArticleViewer >> deleteBrief: aBrief [

	article removeBrief: aBrief.
	self updateArticle
]

{ #category : #'data query' }
ZoaArticleViewer >> directionIcon: aZoaArticleArticleReference [

	^ (aZoaArticleArticleReference citedBy: article)
		  ifTrue: [ self iconNamed: #forward ]
		  ifFalse: [ self iconNamed: #changeBlock ]
]

{ #category : #actions }
ZoaArticleViewer >> exportArticle [

	| folder |
	folder := UIManager default
		          chooseDirectory: 'Exporting directory'
		          from: PlatformResolver forCurrentPlatform home.
	folder ifNotNil: [ zoa exportArticle: article to: folder ]
]

{ #category : #initialization }
ZoaArticleViewer >> initialize [
	super initialize.
	onArticleReloadClicked := [  ]
]

{ #category : #initialization }
ZoaArticleViewer >> initializeNotebook [

	tabs addPage: (self newNotebookPageWith: view and: 'Briefs Editor').
	tabs addPage:
		(self newNotebookPageWith: [ references ] and: 'References').

	tabs addPage: (self newNotebookPageWith: preview and: 'Text preview')
]

{ #category : #initialization }
ZoaArticleViewer >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ].
	
]

{ #category : #initialization }
ZoaArticleViewer >> initializeToolbar [

	toolBar addItemRight: (self newToolbarButton
			 label: 'Delete';
			 icon: (self iconNamed: #smallDelete);
			 help: 'Deletes the spotted article';
			 action: [ self deleteArticle ];
			 yourself).
	toolBar addItemLeft: (self newToolbarButton
			 label: 'Save';
			 icon: (self iconNamed: #smallSave);
			 help: 'Save changes in the spotted article';
			 action: [ self saveArticle ];
			 yourself).

	toolBar addItemLeft: (self newToolbarButton
			 label: 'Refresh';
			 icon: (self iconNamed: #glamorousRefresh);
			 help: 'Refresh the spotted article';
			 action: [ self reloadArticle ];
			 yourself).
			
	
	toolBar addItemLeft: (self newToolbarButton
			 label: 'Comment';
			 icon: (self iconNamed: #announcement);
			 help: 'Add new brief comment to the spotted article ';
			 action: [ self addBrief ];
			 yourself).
	
		
	toolBar addItemLeft: (self newToolbarButton
			 label: 'Read';
			 icon: (self iconNamed: #smallInspectIt);
			 help: 'Read the spotted article';
			 action: [ self openArticlePdf ];
			 yourself).
	
	toolBar addItemLeft: (self newToolbarButton
			 label: 'Export';
			 icon: (self iconNamed: #smallExport);
			 help: 'Export spotted article';
			 action: [ self exportArticle ];
			 yourself).
	


]

{ #category : #initialization }
ZoaArticleViewer >> initializeWidgets [

	toolBar := self newToolbar.
	self initializeToolbar.


	view := self newBriefsList.

	preview := self newText.
	htmlRefs := self newText.
	references := self newReferenceTable.
	tabs := self newNotebook.
	self initializeNotebook
]

{ #category : #actions }
ZoaArticleViewer >> load: item [

	item toReference ensureIsLoadedInto: zoa.
	item fromReference ensureIsLoadedInto: zoa.
	owner updateViewers
]

{ #category : #actions }
ZoaArticleViewer >> loadOrRead: item [

	"["

	(item hasResolvedReferenceIn: zoa)
		ifTrue: [ 
			[ owner readPdf: (item oppositeArticleTo: article using: zoa ) ]
				on: Error
				do: [ :e | self inform: e messageText ] ]
		ifFalse: [ "] on: Error do: [ :e | self inform: e messageText  ]" 
			self load: item ]
]

{ #category : #initialization }
ZoaArticleViewer >> newDataTable [

	^ self newTable
		  addColumn: (SpStringTableColumn evaluated: #key);
		  addColumn: (SpStringTableColumn evaluated: #value);
		  yourself
]

{ #category : #initialization }
ZoaArticleViewer >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #initialization }
ZoaArticleViewer >> newReferenceTable [

	^ self newTable
		  addColumn: ((SpImageTableColumn
				    title: ''
				    evaluated: [ :item | self directionIcon: item ])
				   width: 15;
				   yourself);
		  addColumn: ((SpLinkTableColumn
				    title: 'Load'
				    evaluated: [ :item | 
					    (item hasResolvedReferenceIn: zoa)
						    ifTrue: [ 'READ' ]
						    ifFalse: [ 'LOAD' ] ]
				    action: [ :item | self loadOrRead: item ])
				   width: 20;
				   yourself);
		  addColumn: (SpStringTableColumn
				   title: 'Reference'
				   evaluated: [ :item | 
				   item referenceEntryInRelationWith: article zoa: zoa ]);
		  beResizable;
		  yourself
]

{ #category : #initialization }
ZoaArticleViewer >> onArticleReloadClicked: aBlock [
	onArticleReloadClicked := aBlock
]

{ #category : #actions }
ZoaArticleViewer >> openArticlePdf [
	zoa readArticle: article
]

{ #category : #'data query' }
ZoaArticleViewer >> referencesFor: anArticle [

	allArticles := zoa findAllArticles.
	^ (allArticles flatCollect: [ :a | a references ]) select: [ :ref | 
		  ref isRelatedWith: anArticle ]
]

{ #category : #actions }
ZoaArticleViewer >> reloadArticle [
	onArticleReloadClicked value.
	self updateArticle. 
]

{ #category : #actions }
ZoaArticleViewer >> saveArticle [

	zoa saveArticle: article.
	self inform: 'Saved into database..'
]

{ #category : #'update and set' }
ZoaArticleViewer >> updateArticle [

	article ifNotNil: [ 
		references items: article getAllReferences.
		view items: article briefs.
		preview text:
			(MicroDownParser asText: (article microdownBriefUsing: zoa)) ]
]
