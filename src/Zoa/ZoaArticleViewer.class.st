"
Article viewer
"
Class {
	#name : #ZoaArticleViewer,
	#superclass : #SpPresenter,
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
		'#htmlRefs'
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

{ #category : #add }
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

{ #category : #initialization }
ZoaArticleViewer >> article: anArticle [
	article := anArticle.
	self updateArticle .
]

{ #category : #initialization }
ZoaArticleViewer >> currentAuthors [
	^ article authors
		collect: [ :a | 
			ZoaAuthorWidget new
				author: a;
				yourself ]
]

{ #category : #initialization }
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

{ #category : #initialization }
ZoaArticleViewer >> currentTags [
	^ article tags , article keywords
		collect: [ :t | ZoaTagKeywordWidget new tag: t ]
]

{ #category : #initialization }
ZoaArticleViewer >> deleteArticle [
	Zoa current delete: article.
	self inform: 'Deleted from database... '.
	owner updateViewers .
]

{ #category : #initialization }
ZoaArticleViewer >> deleteBrief: aBrief [
	article briefs remove: aBrief.
	self updateArticle.
]

{ #category : #'as yet unclassified' }
ZoaArticleViewer >> directionIcon: aZoaArticleArticleReference [

	^ (aZoaArticleArticleReference citedBy: article)
		  ifTrue: [ self iconNamed: #forward ]
		  ifFalse: [ self iconNamed: #changeBlock ]
]

{ #category : #initialization }
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
ZoaArticleViewer >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ].
	
]

{ #category : #initialization }
ZoaArticleViewer >> initializeWidgets [

	toolBar := self newToolbar.

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
			 action: [ self deleteArticle ] yourself).

	tabs := self newNotebook.
	abstract := self newText.
	authors := self instantiate: SpComponentListPresenter.
	tags := self instantiate: SpComponentListPresenter.
	view := self instantiate: SpComponentListPresenter.
	viewTabs := self newNotebook.
	preview := self newText.
	htmlRefs  := self newText.
	viewTabs addPage:
		(self newNotebookPageWith: view and: 'Briefs Editor').
	viewTabs addPage:
		(self newNotebookPageWith: preview and: 'Text preview').

	data := self newTable
		        addColumn: (SpStringTableColumn evaluated: #key);
		        addColumn: (SpStringTableColumn evaluated: #value);
		        yourself.
	references := self newTable
		              addColumn: ((SpImageTableColumn
				                title: ''
				                evaluated: [ :item | self directionIcon: item ])
				               width: 15;
				               yourself);
				addColumn: ((SpLinkTableColumn
				                title: 'Load'
				                evaluated: [ :item | 
					                item hasResolvedReference
						                ifTrue: [ 'READ' ]
						                ifFalse: [ 'LOAD' ] ]
				                action: [ :item | self loadOrRead: item ])
				               width: 20;
				               yourself);
		              addColumn: (SpStringTableColumn
				               title: 'Reference'
				               evaluated: [ :item | 
				               item referenceEntryInRelationWith: article ]);
		              
		              beResizable;
		              yourself.

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

	"	newSubPresenter owner: self.
	layout add: newSubPresenter"
]

{ #category : #add }
ZoaArticleViewer >> load: item [
	item to.
	item from. 
	owner updateViewers 
]

{ #category : #add }
ZoaArticleViewer >> loadOrRead: item [
"["
	item hasResolvedReference
		ifTrue: [ [owner readPdf: (item oppositeArticleTo: article )] on: Error do: [ :e | self inform: e messageText ]. ]
		ifFalse: [ self load: item ]
		
		"] on: Error do: [ :e | self inform: e messageText  ]"
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
ZoaArticleViewer >> newStackedComponentWith: anArray [

	| component |
	component := self instantiate: SpDynamicPresenter.
	component layout: SpBoxLayout newVertical.

	anArray do: [ :a | 
		component layout add: a.
		a owner: component ].
	^ component
]

{ #category : #initialization }
ZoaArticleViewer >> onArticleReloadClicked: aBlock [
	onArticleReloadClicked := aBlock
]

{ #category : #initialization }
ZoaArticleViewer >> openArticlePdf [
	article pdfUrl ifNil: [ self inform:  ' must download pdf first '. ^ self  ].
	(#open command arguments: {article pdfUrl}) schedule.
]

{ #category : #initialization }
ZoaArticleViewer >> referencesFor: anArticle [

	 allArticles := Zoa current findAllArticles .
	^ (allArticles flatCollect: [ :a | a references ]) select: [ :ref | 
		  ref isRelatedWith: anArticle ]
]

{ #category : #initialization }
ZoaArticleViewer >> reloadArticle [
	onArticleReloadClicked value.
]

{ #category : #initialization }
ZoaArticleViewer >> saveArticle [
	Zoa new saveArticle: article.
	self inform: 'Saved into database..'
]

{ #category : #initialization }
ZoaArticleViewer >> updateArticle [
	article
		ifNotNil: [ tags items: self currentTags.
			authors items: self currentAuthors.
			data items: article data associations.
			references items: (article allReferences ).
			view items: self currentBriefs.
			preview text: (MicroDownParser asText: article microdownBrief ).
			abstract text:( article abstract ifNil: [ '' ]) ]
]
