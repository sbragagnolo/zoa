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
		'queryModel',
		'window'
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
ZoaDatabaseExplorer class >> openZoaDbExplorer [

	(self new openWithSpec title: 'Zoa') extent: 1200 @ 750
]

{ #category : #specs }
ZoaDatabaseExplorer class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'DB Explorer')
		parent: #Zoa;
		action: [ self openZoaDbExplorer ];
		order: 0;
		help: 'System browser to browse and edit code.';
		iconName: #databaseAdd.
		
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> articlesFor: aTag [

	^ queryModel articles select: [ :a | a keywords includes: aTag ]
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> changeDatabase [

	| kind host database |
	kind := UIManager default
		        chooseFrom: { #Memory. #MongoDB }
		        values: { #memory. #mongo }
		        title:
		        'Choose kind of database. Remember that a memory database will only persist the elements meanwhile is not garbage collected'.

	kind = #memory
		ifTrue: [ Zoa memory beCurrent ]
		ifFalse: [ 
			host := UIManager default
				        request: 'MongoDB Host'
				        initialAnswer: 'localhost'
				        title: 'Change Database'.

			database := UIManager default
				            request: 'MongoDB Database name'
				            initialAnswer: 'zoa'
				            title: 'Change Database'.
			(Zoa host: host database: database) beCurrent ].
	self updateViewers.
	window close.
	self class openZoaDbExplorer.
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

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> createNewArticle [
	| doi article |
	
	doi := UIManager default request:'Please enter a valid DOI'. 
	doi ifNil: [ ^ self ].
	article := ZoaArticle new .
	article doi: doi. 
	self openArticleMetadata: article.
	
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

	articles selectItems: { aZoaArticle }.

	self selectArticle: articles selection
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

toolbar addItemLeft: (self newToolbarButton
			 label: 'ChangeDB';
			 icon: (self iconNamed: #database);
			 help: 'Chande DataBase';
			 action: [ self changeDatabase ];
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

{ #category : #actions }
ZoaDatabaseExplorer >> initializeWindow: aWindow [
	super initializeWindow: aWindow.
	window := aWindow 
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
				 beSortable;
				 yourself);
		addColumn:
			((SpStringTableColumn title: 'Author' evaluated: [ :item | 
					  | fa |
					  fa := item firstAuthor.
					  fa
						  ifNil: [ 'Unknown Author' ]
						  ifNotNil: [ zoa findAuthorByIds: fa authorIds ] ])
				 width: 100;
				 beSortable;
				 yourself);
		addColumn:
			(SpStringTableColumn
				 title: 'Title'
				 evaluated: [ :item | item title ]) beSortable;
		yourself;
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
ZoaDatabaseExplorer >> newKeywordsView [

	| table |
	table := self newTreeTable.

	table
		addColumn: (SpCompositeTableColumn new
				 title: 'Name';
				 addColumn: ((SpImageTableColumn evaluated: #systemIcon)
						  width: 20;
						  yourself);
				 addColumn: ( (SpStringTableColumn evaluated: #name) beSortable; yourself  );
				 yourself);
		roots: {  };
		children: [ :aTag | 
			(aTag isKindOf: ZoaTag)
				ifTrue: [ self articlesFor: aTag. ]
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

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> openAuthorEditingDialog: anAuthor [

	| author |
	author := self instantiate: ZoaAuthorWidget.
	author author: anAuthor.
	author openDialogWithSpec
		okAction: [ author pushChanges ];
		title: anAuthor fullName
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> openInBrowser: anArticle [
 	WebBrowser openOn: anArticle link
]

{ #category : #actions }
ZoaDatabaseExplorer >> readPdf: anArticle [

	zoa readArticle: anArticle 
]

{ #category : #actions }
ZoaDatabaseExplorer >> readPdf: anArticle using: aZoa [

	zoa readArticle: anArticle.
	
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

	aSelection selectedItem ifNotNil: [ :val | 
		preview article: val.
		window ifNotNil: [ window title: val title ] ]
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
