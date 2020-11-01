"
Article viewer
"
Class {
	#name : #ZoaArticleViewer,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#article => SpObservableSlot',
		'#view',
		'#viewTabs',
		'#preview',
		'#tags',
		'#authors',
		'#data',
		'#toolBar',
		'#onArticleReloadClicked',
		'#tabs',
		'#references',
		'#allArticles',
		'#abstract',
		'#htmlRefs',
		'#zoa'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaArticleViewer class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolBar height: self toolbarHeight;
		  add: (SpPanedLayout newHorizontal
				   position: 250;
				   add: (SpBoxLayout newVertical
						    add: #tabs;
						    yourself);
				   add: #viewTabs;
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

{ #category : #'data query' }
ZoaArticleViewer >> currentAuthors [
	^ article authors
		collect: [ :a | 
			ZoaAuthorWidget new
				author: a;
				yourself ]
]

{ #category : #'data query' }
ZoaArticleViewer >> currentBriefs [

	article briefs ifEmpty: [ 
		article briefs add: (ZoaBrief new
				 name: #Motivation;
				 yourself) ].
	^ article briefs collect: [ :b | 
		  ZoaBriefWidget new
			  brief: b;
			  onDelete: [ :br | self deleteBrief: br ];
			  yourself ]
]

{ #category : #'data query' }
ZoaArticleViewer >> currentTags [

	^ (article tags , article keywords) asOrderedCollection 
]

{ #category : #actions }
ZoaArticleViewer >> deleteArticle [
	Zoa current delete: article.
	self inform: 'Deleted from database... '.
	owner updateViewers .
]

{ #category : #actions }
ZoaArticleViewer >> deleteBrief: aBrief [
	article briefs remove: aBrief.
	self updateArticle.
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
	folder ifNotNil: [ Zoa current exportArticle: article to: folder ]
]

{ #category : #initialization }
ZoaArticleViewer >> initialize [
	super initialize.
	onArticleReloadClicked := [  ]
]

{ #category : #initialization }
ZoaArticleViewer >> initializeNotebook [

	tabs addPage:
		(self newNotebookPageWith: [ references ] and: 'References').
	tabs addPage: (self
			 newNotebookPageWith: [ 
				 self newStackedComponentWith: { 
						 abstract.
						 data.
						 tags } ]
			 and: 'Metadata').
	tabs addPage: (self newNotebookPageWith: authors and: 'Authors')

	
]

{ #category : #initialization }
ZoaArticleViewer >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ].
	
]

{ #category : #initialization }
ZoaArticleViewer >> initializeToolbar [

	toolBar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #add);
			 action: [ self addBrief ] yourself).
	toolBar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #refresh);
			 action: [ self reloadArticle ] yourself).
	toolBar addItemLeft: (self newToolbarButton
			 icon: (Smalltalk ui icons iconNamed: #open);
			 action: [ self openArticlePdf ] yourself).
	toolBar addItemRight: (self newToolbarButton
			 label: 'Save';
			 action: [ self saveArticle ] yourself).
	toolBar addItemRight: (self newToolbarButton
			 label: 'Export';
			 action: [ self exportArticle ] yourself).
	toolBar addItemRight: (self newToolbarButton
			 label: 'Delete';
			 action: [ self deleteArticle ] yourself)
]

{ #category : #initialization }
ZoaArticleViewer >> initializeViewtabs [

	viewTabs addPage:
		(self newNotebookPageWith: view and: 'Briefs Editor').
	viewTabs addPage:
		(self newNotebookPageWith: preview and: 'Text preview')
]

{ #category : #initialization }
ZoaArticleViewer >> initializeWidgets [

	toolBar := self newToolbar.
	self initializeToolbar.
	abstract := self newText.
	authors := self newAuthorList.
	tags := self newTagsList.
	tags onDeleteTag: [ :t | article removeKeyword:  t ]. 
	tags onAddTags: [ :t | article addKeyword: t ].
	view := self instantiate: SpComponentListPresenter.

	preview := self newText.
	htmlRefs := self newText.
	viewTabs := self newNotebook.
	self initializeViewtabs.

	data := self newDataTable.
	references := self newReferenceTable.
	tabs := self newNotebook.
	self initializeNotebook
]

{ #category : #actions }
ZoaArticleViewer >> load: item [
	item toReference  ensureIsLoadedInto: Zoa current .
	item fromReference ensureIsLoadedInto: Zoa current .  
	owner updateViewers 
]

{ #category : #actions }
ZoaArticleViewer >> loadOrRead: item [
"["
	(item hasResolvedReferenceIn: Zoa current )
		ifTrue: [ [owner readPdf: (item oppositeArticleTo: article )] on: Error do: [ :e | self inform: e messageText ]. ]
		ifFalse: [ self load: item ]
		
		"] on: Error do: [ :e | self inform: e messageText  ]"
]

{ #category : #initialization }
ZoaArticleViewer >> newAuthorList [

	^ self instantiate: SpComponentListPresenter
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
					    (item hasResolvedReferenceIn: Zoa current)
						    ifTrue: [ 'READ' ]
						    ifFalse: [ 'LOAD' ] ]
				    action: [ :item | self loadOrRead: item ])
				   width: 20;
				   yourself);
		  addColumn: (SpStringTableColumn
				   title: 'Reference'
				   evaluated: [ :item | 
				   item referenceEntryInRelationWith: article zoa: Zoa current ]);
		  beResizable;
		  yourself
]

{ #category : #initialization }
ZoaArticleViewer >> newTagsList [

	^ self instantiate: ZoaTagsWidget 
]

{ #category : #initialization }
ZoaArticleViewer >> onArticleReloadClicked: aBlock [
	onArticleReloadClicked := aBlock
]

{ #category : #actions }
ZoaArticleViewer >> openArticlePdf [
	article pdfUrl ifNil: [ self inform:  ' must download pdf first '. ^ self  ].
	(#open command arguments: {article pdfUrl}) schedule.
]

{ #category : #'data query' }
ZoaArticleViewer >> referencesFor: anArticle [

	 allArticles := Zoa current findAllArticles .
	^ (allArticles flatCollect: [ :a | a references ]) select: [ :ref | 
		  ref isRelatedWith: anArticle ]
]

{ #category : #actions }
ZoaArticleViewer >> reloadArticle [
	onArticleReloadClicked value.
]

{ #category : #actions }
ZoaArticleViewer >> saveArticle [
	Zoa new saveArticle: article.
	self inform: 'Saved into database..'
]

{ #category : #'update and set' }
ZoaArticleViewer >> updateArticle [

	article ifNotNil: [ 
		tags tags: self currentTags.
		authors items: self currentAuthors.
		data items: article data associations.
		references items: article getAllReferences.
		view items: self currentBriefs.
		preview text: (MicroDownParser asText: article microdownBrief).
		abstract text: (article abstract ifNil: [ '' ]) ]
]
