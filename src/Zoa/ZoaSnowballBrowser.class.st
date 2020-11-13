Class {
	#name : #ZoaSnowballBrowser,
	#superclass : #ZoaPresenter,
	#instVars : [
		'listables',
		'preview',
		'toolbar',
		'query',
		'articles',
		'authors',
		'keywords',
		'queryModel',
		'window',
		'discoverer'
	],
	#category : #'Zoa-Snowball-UI'
}

{ #category : #specs }
ZoaSnowballBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolbar height: self toolbarHeight * 1.5;
		add:
			(SpPanedLayout newHorizontal
				position: 20 percent;
				add: #listables;
				add: #preview;
				yourself);
		
		add: #query height: 200;
		yourself
]

{ #category : #specs }
ZoaSnowballBrowser class >> example [

	self new openWithSpec  title: 'Zoa'
]

{ #category : #specs }
ZoaSnowballBrowser class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Snowball explorer')
		parent: #Zoa;
		action: [ (self new openWithSpec title: 'Zoa') extent: 1200@750];
		order: 0;
		help: 'Zoa browser to help finding references';
		iconName: #glamorousSearch.
		
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> articlesFor: aTag [

	^ queryModel articles select: [ :a | a keywords includes: aTag ]
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> contextMenuForArticle [

	^ self newMenu
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Inspect Article';
						  action: [ articles selectedItem inspect ] ];
				 
				  addItem: [ :anItem | 
					  anItem
						  name: 'Import All References';
						  action: [ self importReferences: articles selectedItem ] ];
					addItem: [ :anItem | 
					  anItem
						  name: 'Load references and citations from HTML';
						  action: [ self importCitationsAndReferences: articles selectedItem ] ];
					addItem: [ :anItem | 
					  anItem
						  name: 'Open in browser';
						  action: [ self openInBrowser: articles selectedItem ] ];
					 addItem: [ :anItem | 
					  anItem
						  name: 'Read!';
						  action: [ self readPdf: articles selectedItem ] ] ];
		  yourself
]

{ #category : #'data query' }
ZoaSnowballBrowser >> defaultQueryText [
	^ '
	"Selecting articles sets the widget articles to a specific query result "
	self select: (self zoa findAllArticles select: [ :a | a cites size between: 5 and: 20  ]).
	
	"Reset does set the articles to be fully fetch on updates"
	self reset.
	'
]

{ #category : #'as yet unclassified' }
ZoaSnowballBrowser >> focusOn: aZoaArticle [

	articles selectItems: { aZoaArticle }.

	self selectArticle: articles selection
]

{ #category : #actions }
ZoaSnowballBrowser >> importArticleDoi [

	| doi |
	doi := UIManager default
		       request: 'Insert a DOI to an article to import'
		       initialAnswer: ''
		       title: 'Import Article From DOI'.
	doi ifNil: [ ^ self ].
	discoverer importDoi: doi.
	self updateViewers
]

{ #category : #actions }
ZoaSnowballBrowser >> importArticleUrl [

	| url |
	url := UIManager default
		       request: 'Insert a url to an article to import'
		       initialAnswer: 'http://'
		       title: 'Import Article From URL'.
	url ifNil: [ ^ self ].
	discoverer importUrl: url asZnUrl.
	self updateViewers
]

{ #category : #actions }
ZoaSnowballBrowser >> importCitationsAndReferences: anArticle [

	| html visitor text |
	anArticle isIEEE ifTrue: [ visitor := ZoaIEEEVisitor new ].
	anArticle isWiley ifTrue: [ visitor := ZoaWileyVisitor new ].
	visitor ifNil: [ 
		self error:
			' No HTML Reference loader for ' , anArticle publisher asString ].
	text := self newText.
	(text
		 autoAccept: true;
		 yourself) openDialogWithSpec okAction: [ 
		html := text text asString parseHTML.

		visitor article: anArticle.
		html acceptNodeVisitor: visitor.
		zoa saveArticle: anArticle ]
]

{ #category : #actions }
ZoaSnowballBrowser >> importReferences: anArticle [

	zoa importAllReferencesRelatedWith: anArticle.
	self updateViewers
]

{ #category : #initialization }
ZoaSnowballBrowser >> initializePresenters [

	super initializePresenters.
	articles contextMenu: self contextMenuForArticle.
	self updateViewers
]

{ #category : #initialization }
ZoaSnowballBrowser >> initializeQuery [

	query := self newCode.
	query text: self defaultQueryText.
	queryModel owner: self.
	query beForObject: queryModel
]

{ #category : #initialization }
ZoaSnowballBrowser >> initializeToolbar [

	toolbar addItemLeft: (self newToolbarButton
		 label: 'Import URL';
		 icon: (self iconNamed: #glamorousCloud);
		 help: 'Import Article Using URL';
		 action: [ self importArticleUrl ];
		 yourself).


	toolbar addItemLeft: (self newToolbarButton
		 label: 'Import DOI';
		 icon: (self iconNamed: #smallBarcode);
		 help: 'Import Article Using DOI';
		 action: [ self importArticleDoi ];
		 yourself)
]

{ #category : #initialization }
ZoaSnowballBrowser >> initializeWidgets [

	super initializeWidgets.
	queryModel := ZoaQueryModel new.
	queryModel zoa: zoa.
	toolbar := self newToolbar.

	self initializeToolbar.
	discoverer := ZoaSBReferenceDiscoverer new
		zoa: zoa;
		yourself.
	self initializeQuery.

	"Initialize the left pane with the review queue"
	listables := self newNotebook.
	articles := self newArticleView.
	listables addPage: (self newNotebookPageWith: articles and: 'Review Queue').
	
	"Initialize the right pane, the article details"
	preview := self instantiate: ZoaSnowballArticlePreviewPresenter.
	preview whenArticleKeptDo: [ :article |
		discoverer keepArticle: article ].
	preview whenArticleDiscardedDo: [ :article |
		discoverer discardArticle: article ].
	preview whenReferenceQueuedDo: [ :reference |
		discoverer queueReference: reference.
		self updateViewers ].
]

{ #category : #actions }
ZoaSnowballBrowser >> initializeWindow: aWindow [
	super initializeWindow: aWindow.
	window := aWindow 
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> newArticleView [

	| table |
	table := self newTable.
	table
		addColumn: (SpStringTableColumn
			title: 'Title'
			evaluated: [ :item | item title ]);
		whenSelectionChangedDo: [ :selection | 
			self selectArticle: selection ];
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | 
			self openArticleMetadata: selection selectedItem ];
		beResizable.
	^ table
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> newAuthorsView [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a fullName < b fullName ];
		addColumn: ((SpStringTableColumn
				  title: 'Articles'
				  evaluated: [ :item | item articles size asString ])
				 width: 50;
				 beSortable;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Author'
				  evaluated: [ :item | item fullName asString ])
				 beSortable;
				 yourself);
		activateOnDoubleClick;
		whenActivatedDo: [ :l | self openAuthorEditingDialog: l selectedItem ];
		beResizable.
	^ table
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> openArticleMetadata: anArticle [

	((self instantiate: ZoaArticleMetadata)
		 article: anArticle;
		 openWithSpec)
		extent: 720.0 @ 578.0;
		title: (anArticle title readStream next: 50)
]

{ #category : #'widget creation' }
ZoaSnowballBrowser >> openAuthorEditingDialog: anAuthor [

	| author |
	author := self instantiate: ZoaAuthorWidget.
	author author: anAuthor.
	author openDialogWithSpec
		okAction: [ author pushChanges ];
		title: anAuthor fullName
]

{ #category : #'as yet unclassified' }
ZoaSnowballBrowser >> openInBrowser: anArticle [
 	WebBrowser openOn: anArticle link
]

{ #category : #actions }
ZoaSnowballBrowser >> readPdf: anArticle [

	zoa readArticle: anArticle 
]

{ #category : #actions }
ZoaSnowballBrowser >> readPdf: anArticle using: aZoa [

	zoa readArticle: anArticle.
	
]

{ #category : #actions }
ZoaSnowballBrowser >> selectArticle: aSelection [

	aSelection selectedItem ifNotNil: [ :val | 
		preview article: val.
		window ifNotNil: [ window title: val title ] ]
]

{ #category : #'as yet unclassified' }
ZoaSnowballBrowser >> updateViewers [

	articles items: discoverer articleQueue
]
