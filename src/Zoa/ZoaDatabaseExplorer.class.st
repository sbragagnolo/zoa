Class {
	#name : #ZoaDatabaseExplorer,
	#superclass : #ZoaPresenter,
	#instVars : [
		'listables',
		'preview',
		'toolbar',
		'query',
		'articles',
		'authors',
		'keywords',
		'queryModel'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaDatabaseExplorer class >> defaultSpec [
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
ZoaDatabaseExplorer class >> example [

	self new openWithSpec  title: 'Zoa'
]

{ #category : #specs }
ZoaDatabaseExplorer class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'DB Explorer')
		parent: #Zoa;
		action: [ (self new openWithSpec title: 'Zoa') extent: 1200@750];
		order: 0;
		help: 'System browser to browse and edit code.';
		iconName: #databaseAdd.
		
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> contextMenuForArticle [

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
ZoaDatabaseExplorer >> defaultQueryText [
	^ '
	"Selecting articles sets the widget articles to a specific query result "
	self select: (self zoa findAllArticles select: [ :a | a cites size between: 5 and: 20  ]).
	
	"Reset does set the articles to be fully fetch on updates"
	self reset.
	'
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> focusOn: aZoaArticle [ 
	articles selectItems: { aZoaArticle  }
]

{ #category : #actions }
ZoaDatabaseExplorer >> importArticleDoi [

	| doi |
	doi := UIManager default
		       request: 'Insert a DOI to an article to import'
		       initialAnswer: ''
		       title: 'Import Article From DOI'.
	doi ifNil: [ ^ self ].
	zoa loadAndSaveArticleDoi: doi.
	self updateViewers
]

{ #category : #actions }
ZoaDatabaseExplorer >> importArticleUrl [

	| url |
	url := UIManager default
		       request: 'Insert a url to an article to import'
		       initialAnswer: 'http://'
		       title: 'Import Article From URL'.
	url ifNil: [ ^ self ].
	zoa loadAndSaveArticleUrl: url asZnUrl.
	self updateViewers
]

{ #category : #actions }
ZoaDatabaseExplorer >> importCitationsAndReferences: anArticle [

	| html visitor text |
	text := self newText.
	(text
		 autoAccept: true;
		 yourself) openDialogWithSpec okAction: [ 
		html := text text asString parseHTML.
		visitor := ZoaIEEEVisitor new.
		visitor article: anArticle.
		html acceptNodeVisitor: visitor.
		zoa saveArticle: anArticle ]
]

{ #category : #actions }
ZoaDatabaseExplorer >> importReferences: anArticle [

	zoa importAllReferencesRelatedWith: anArticle.
	self updateViewers
]

{ #category : #initialization }
ZoaDatabaseExplorer >> initializePresenters [

	super initializePresenters.
	articles contextMenu: self contextMenuForArticle.
	self updateViewers
]

{ #category : #initialization }
ZoaDatabaseExplorer >> initializeQuery [

	query := self newCode.
	query text: self defaultQueryText.
	queryModel owner: self.
	query beForObject: queryModel
]

{ #category : #initialization }
ZoaDatabaseExplorer >> initializeToolbar [

	toolbar addItemLeft: (self newToolbarButton
			 label: 'Import';
			 icon: (self iconNamed: #glamorousCloud);
			 help: 'Import Article Using URL';
			 action: [ self importArticleUrl ];
			 yourself).


	toolbar addItemLeft: (self newToolbarButton
			 label: 'Import';
			 icon: (self iconNamed: #smallBarcode);
			 help: 'Import Article Using DOI';
			 action: [ self importArticleDoi ];
			 yourself).

	toolbar addItemLeft: (self newToolbarButton
			 label: 'Create';
			 icon: (self iconNamed: #glamorousAdd);
			 help: 'Create New Article';
			 action: [ self createNewArticle ];
			 yourself).

	toolbar addItemLeft: (self newToolbarButton
			 label: 'Refresh';
			 icon: (self iconNamed: #glamorousRefresh);
			 help: 'Refresh UI';
			 action: [ self updateViewers ];
			 yourself).

	toolbar addItemRight: (self newToolbarButton
			 label: 'Destroy';
			 icon: (self iconNamed: #packageDelete);
			 help: 'Destroys the WHOLE DB. Reviews included.';
			 action: [ self removeAll ];
			 yourself).

]

{ #category : #initialization }
ZoaDatabaseExplorer >> initializeWidgets [

	super initializeWidgets.
	queryModel := ZoaQueryModel new.
	queryModel zoa: zoa.
	toolbar := self newToolbar.

	self initializeToolbar.
	self initializeQuery.

	listables := self newNotebook.
	articles := self newArticleView.
	authors := self newAuthorsView.
	keywords := self newKeywordsView.
	preview := self instantiate: ZoaArticleViewer.
	"spec script: [ :view | view addShape: RSBox new. value := value + 1 ]."
	listables
		addPage: (self newNotebookPageWith: articles and: 'Articles');
		addPage: (self newNotebookPageWith: authors and: 'Authors');
		addPage: (self newNotebookPageWith: keywords and: 'Keywords')
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> newArticleView [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a title < b title ];
		addColumn: ((SpStringTableColumn
				  title: 'Date'
				  evaluated: [ :item | item date year asString ])
				 width: 50;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Author'
				  evaluated: [ :item | item firstAuthorName ])
				 width: 100;
				 yourself);
		addColumn:
		(SpStringTableColumn
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
ZoaDatabaseExplorer >> newAuthorsView [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a fullName < b fullName ];
		addColumn: (SpStringTableColumn
				 title: 'Author'
				 evaluated: [ :item | item fullName asString ]);
		addColumn: ((SpStringTableColumn
				  title: 'Articles'
				  evaluated: [ :item | item articles size asString ])
				 width: 100;
				 yourself);
		
	
		beResizable.
	^ table
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> newKeywordsView [

	| table |
	table := self newTreeTable.

	table
		addColumn: (SpCompositeTableColumn new
				 title: 'Name';
				 addColumn: ((SpImageTableColumn evaluated: #systemIcon)
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		roots: {  };
		children: [ :aTag | 
			(aTag isKindOf: ZoaTag)
				ifTrue: [ aTag articles asOrderedCollection ]
				ifFalse: [ {  } ] ];
		beResizable.
	
	^ table
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> openArticleMetadata: anArticle [

	((self instantiate: ZoaArticleMetadata)
		 article: anArticle;
		 openWithSpec)
		extent: 720.0 @ 578.0;
		title: (anArticle title readStream next: 50)
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> openInBrowser: anArticle [
 	WebBrowser openOn: anArticle link
]

{ #category : #actions }
ZoaDatabaseExplorer >> readPdf: anArticle [ 

	(#open command arguments: { (anArticle pdfFileUsing: zoa ) fullName }) schedule
]

{ #category : #actions }
ZoaDatabaseExplorer >> readPdf: anArticle using: aZoa [

	(#open command arguments: { (anArticle pdfFileUsing: aZoa) fullName }) schedule
]

{ #category : #actions }
ZoaDatabaseExplorer >> removeAll [

	(UIManager default confirm:
		 ' This command is going to delete the whole database. Are you sure? ') 
		ifTrue: [ 
			(UIManager default confirm: ' You have a second chance! ') ifTrue: [ 
				zoa dropDatabase.
				self updateViewers ] ]
]

{ #category : #actions }
ZoaDatabaseExplorer >> selectArticle: aSelection [

	aSelection selectedItem ifNotNil: [ :val | preview article: val ]
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> updateViewers [

	articles items: queryModel articles.
	authors items:
		(zoa findAllAuthors select: [ :a | a articles isNotEmpty ]).
	keywords roots:
		(queryModel articles flatCollect: [ :t | t keywords ]) asSet
			asOrderedCollection
]
