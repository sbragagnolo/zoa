Class {
	#name : #ZoaSnowballArticlePreviewPresenter,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#article => SpObservableSlot',
		'#view',
		'#preview',
		'#toolBar',
		'#onArticleReloadClicked',
		'#tabs',
		'#references',
		'#allArticles',
		'#whenArticleKeptCallback',
		'#whenArticleDiscardedCallback',
		'#whenReferenceQueuedCallback'
	],
	#category : #'Zoa-Snowball-UI'
}

{ #category : #specs }
ZoaSnowballArticlePreviewPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolBar height: self toolbarHeight * 1.5;
		  add: (SpBoxLayout newVertical
				   add: #tabs;
				   yourself)
]

{ #category : #specs }
ZoaSnowballArticlePreviewPresenter class >> example [
	<example>
	self new
		article: (Zoa new loadAndSaveArticleDoi: '10.1145/3139903.3139909');
		openWithSpec
]

{ #category : #'update and set' }
ZoaSnowballArticlePreviewPresenter >> article: anArticle [
	article := anArticle.
	self updateArticle .
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> deleteArticle [
	zoa delete: article.
	self inform: 'Deleted from database... '.
	owner updateViewers .
]

{ #category : #'data query' }
ZoaSnowballArticlePreviewPresenter >> directionIcon: aZoaArticleArticleReference [

	^ (aZoaArticleArticleReference citedBy: article)
		  ifTrue: [ self iconNamed: #forward ]
		  ifFalse: [ self iconNamed: #changeBlock ]
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> exportArticle [

	| folder |
	folder := UIManager default
		          chooseDirectory: 'Exporting directory'
		          from: PlatformResolver forCurrentPlatform home.
	folder ifNotNil: [ zoa exportArticle: article to: folder ]
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> initialize [
	super initialize.
	onArticleReloadClicked := [  ]
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> initializeNotebook [

	tabs addPage: (self newNotebookPageWith: preview and: 'Text preview').
	tabs addPage: (self newNotebookPageWith: [ references ] and: 'References').
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ].
	
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> initializeToolbar [

	toolBar addItemLeft: (self newToolbarButton
			 label: 'Keep it';
			 icon: (self iconNamed: #thumbsUp);
			 help: 'This paper is interesting for my search!';
			 action: [ self keepArticle ];
			 yourself).

	toolBar addItemLeft: (self newToolbarButton
			 label: 'Discard it';
			 icon: (self iconNamed: #thumbsDown);
			 help: 'This paper is not interesting for my search!';
			 action: [ self discardArticle ];
			 yourself).

	toolBar addItemLeft: (self newToolbarButton
			 label: 'Queue All refs';
			 icon: (self iconNamed: #glamorousLeftSide);
			 help: 'Queue all the discovered refs from/to this paper';
			 action: [ self queueAllRefs ];
			 yourself).
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> initializeWidgets [

	toolBar := self newToolbar.
	self initializeToolbar.

	view := self newBriefsList.

	preview := self newText.
	references := self newReferenceTable.
	tabs := self newNotebook.
	self initializeNotebook
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> load: item [

	item toReference ensureIsLoadedInto: zoa.
	item fromReference ensureIsLoadedInto: zoa.
	owner updateViewers
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> loadOrRead: item [

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
ZoaSnowballArticlePreviewPresenter >> newDataTable [

	^ self newTable
		  addColumn: (SpStringTableColumn evaluated: #key);
		  addColumn: (SpStringTableColumn evaluated: #value);
		  yourself
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #initialization }
ZoaSnowballArticlePreviewPresenter >> newReferenceTable [

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
ZoaSnowballArticlePreviewPresenter >> onArticleReloadClicked: aBlock [
	onArticleReloadClicked := aBlock
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> openArticlePdf [
	zoa readArticle: article
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> queueAllRefs [
	
	article references do: [ :e |
		whenReferenceQueuedCallback value: e ]
]

{ #category : #'data query' }
ZoaSnowballArticlePreviewPresenter >> referencesFor: anArticle [

	allArticles := zoa findAllArticles.
	^ (allArticles flatCollect: [ :a | a references ]) select: [ :ref | 
		  ref isRelatedWith: anArticle ]
]

{ #category : #actions }
ZoaSnowballArticlePreviewPresenter >> saveArticle [

	zoa saveArticle: article.
	self inform: 'Saved into database..'
]

{ #category : #'update and set' }
ZoaSnowballArticlePreviewPresenter >> updateArticle [

	article ifNotNil: [ 
		references items: article getAllReferences.
		preview text: (MicroDownParser asText: (article microdownShortBriefUsing: zoa)) ]
]

{ #category : #events }
ZoaSnowballArticlePreviewPresenter >> whenArticleDiscardedDo: aFullBlockClosure [ 

	whenArticleDiscardedCallback := aFullBlockClosure
]

{ #category : #events }
ZoaSnowballArticlePreviewPresenter >> whenArticleKeptDo: aFullBlockClosure [
	
	whenArticleKeptCallback := aFullBlockClosure
]

{ #category : #events }
ZoaSnowballArticlePreviewPresenter >> whenReferenceQueuedDo: aFullBlockClosure [ 

	whenReferenceQueuedCallback := aFullBlockClosure
]
