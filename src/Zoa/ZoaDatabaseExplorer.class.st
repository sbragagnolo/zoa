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
		add: #toolbar height: self toolbarHeight;
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
		action: [ self new openWithSpec title: 'Zoa' ];
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
	
	doi := UIManager default request: 'Insert a DOI to an article to import' 
		initialAnswer: '' 
		title: 'Import Article From DOI'.
	doi ifNil: [ ^ self ].
	Zoa current loadAndSaveArticleDoi: doi. 
	self updateViewers.

	
]

{ #category : #actions }
ZoaDatabaseExplorer >> importArticleUrl [
	| url |
	
	url := UIManager default request: 'Insert a url to an article to import' 
		initialAnswer: 'http://' 
		title: 'Import Article From URL'.
	url ifNil: [ ^ self ].
	Zoa current loadAndSaveArticleUrl: url asZnUrl . 
	self updateViewers.

	
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
		Zoa current saveArticle: anArticle 
		]
]

{ #category : #actions }
ZoaDatabaseExplorer >> importReferences: anArticle [
	Zoa current importAllReferencesRelatedWith: anArticle .
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
ZoaDatabaseExplorer >> initializeToolbar [.
	toolbar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #add);
			 action: [ self importArticleUrl ] yourself).
	toolbar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #add);
			 action: [ self importArticleDoi ] yourself).
	toolbar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #refresh);
			 action: [ self updateViewers ] yourself).
	toolbar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #remove);
			 action: [ self removeAll ] yourself).
	
]

{ #category : #initialization }
ZoaDatabaseExplorer >> initializeWidgets [

	super initializeWidgets.
	queryModel := ZoaQueryModel new. 
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
				 title: 'Date' evaluated: [ :item | item date year asString ])
				 width: 50;
				 yourself);
		addColumn: ((SpStringTableColumn
				 title: 'Author' evaluated: [ :item | item firstAuthorName ])
				 width: 100;
				 yourself);
		addColumn:
		(SpStringTableColumn
			 title: 'Title'
			 evaluated: [ :item | item title ]);
		whenSelectionChangedDo: [ :selection | 
		self selectArticle: selection ];
		beResizable.
	^ table
]

{ #category : #'widget creation' }
ZoaDatabaseExplorer >> newAuthorsView [
	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a fullName < b fullName ];
		addColumn: (SpStringTableColumn title: 'CiteName' evaluated: [ :item | item citeName asString ]);
		addColumn: (SpStringTableColumn title: 'Articles' evaluated: [ :item | item articles size asString ]);
		addColumn: (SpStringTableColumn title: 'Keywords' evaluated: [ :item |  ';' join: (item articles flatCollect: [ :a | a keywords ]) ]);
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

{ #category : #actions }
ZoaDatabaseExplorer >> readPdf: anArticle [

	(#open command arguments: { anArticle pdfFile fullName }) schedule
]

{ #category : #actions }
ZoaDatabaseExplorer >> removeAll [

	(UIManager default confirm:
		 ' This command is going to delete the whole database. Are you sure? ') 
		ifTrue: [ 
			(UIManager default confirm: ' You have a second chance! ') ifTrue: [ 
				Zoa current dropDatabase  . self updateViewers  ] ].
]

{ #category : #actions }
ZoaDatabaseExplorer >> selectArticle: aSelection [

	aSelection selectedItem ifNotNil: [ :val | preview article: val ]
]

{ #category : #'as yet unclassified' }
ZoaDatabaseExplorer >> updateViewers [

	articles items: queryModel articles.
	authors items:
		(Zoa current findAllAuthors select: [ :a | a articles isNotEmpty ]).
	keywords roots:
		(queryModel articles flatCollect: [ :t | t keywords ]) asSet asOrderedCollection 
]
