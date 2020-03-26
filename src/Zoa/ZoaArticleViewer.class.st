"
Article viewer
"
Class {
	#name : #ZoaArticleViewer,
	#superclass : #SpPresenter,
	#instVars : [
		'#article => SpObservableSlot',
		'#view',
		'#tags',
		'#authors',
		'#data',
		'#toolBar',
		'#onArticleReloadClicked'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaArticleViewer class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar height: self toolbarHeight;
		add:
			(SpPanedLayout newHorizontal
				position: 950;
				add: #view ;
				add:
					(SpBoxLayout newVertical
						add: #authors;
						add: #tags;
						add: #data;
						yourself) ;
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
	article briefs
		ifEmpty: [ article briefs
				add:
					(ZoaBrief new
						name: #Motivation;
						yourself);
				add:
					(ZoaBrief new
						name: #ExpectedResults;
						yourself);
				add:
					(ZoaBrief new
						name: #ResultsProperties;
						yourself) ;
				add:
					(ZoaBrief new
						name: #ProposedMethod;
						yourself);
				add:
					(ZoaBrief new
						name: #Validation;
						yourself);
				add:
					(ZoaBrief new
						name: #Conclusion;
						yourself)    ].
	^ article briefs
		collect: [ :b | 
			ZoaBriefWidget new
				brief: b;
				onDelete: [ : br | self deleteBrief: br ];
				yourself ]
]

{ #category : #initialization }
ZoaArticleViewer >> currentTags [
	^ article tags , article keywords
		collect: [ :t | ZoaTagKeywordWidget new tag: t ]
]

{ #category : #initialization }
ZoaArticleViewer >> deleteArticle [
	Zoa new delete: article.
	self inform: 'Deleted from database... '
]

{ #category : #initialization }
ZoaArticleViewer >> deleteBrief: aBrief [
	article briefs remove: aBrief.
	self updateArticle.
]

{ #category : #initialization }
ZoaArticleViewer >> initialize [
	super initialize.
	onArticleReloadClicked := [  ]
]

{ #category : #initialization }
ZoaArticleViewer >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ]
]

{ #category : #initialization }
ZoaArticleViewer >> initializeWidgets [
	toolBar := self newToolBar.
	toolBar := self newToolBar.
	toolBar
		addItemLeft:
			(SpToolBarButton new
				icon: (Smalltalk ui icons iconNamed: #add);
				action: [ self addBrief ] yourself).
	toolBar
		addItemLeft:
			(SpToolBarButton new
				icon: (Smalltalk ui icons iconNamed: #refresh);
				action: [ self reloadArticle ] yourself).
	toolBar
		addItemLeft:
			(SpToolBarButton new
				icon: (Smalltalk ui icons iconNamed: #open);
				action: [ self openArticlePdf ] yourself).
	toolBar
		addItemRight:
			(SpToolBarButton new
				label: 'Save';
				action: [ self saveArticle ] yourself).
	toolBar
		addItemRight:
			(SpToolBarButton new
				label: 'Delete';
				action: [ self deleteArticle ] yourself).
	authors := self instantiate: SpComponentListPresenter.
	tags := self instantiate: SpComponentListPresenter.
	view := self instantiate: SpComponentListPresenter.
	data := self newTable
		addColumn: (SpStringTableColumn evaluated: #key);
		addColumn: (SpStringTableColumn evaluated: #value);
		yourself
]

{ #category : #initialization }
ZoaArticleViewer >> onArticleReloadClicked: aBlock [
	onArticleReloadClicked := aBlock
]

{ #category : #initialization }
ZoaArticleViewer >> openArticlePdf [
	(#open command arguments: {article pdfUrl}) schedule.
]

{ #category : #initialization }
ZoaArticleViewer >> reloadArticle [
	onArticleReloadClicked value.
]

{ #category : #initialization }
ZoaArticleViewer >> saveArticle [
	Zoa new save: article.
	self inform: 'Saved into database..'
]

{ #category : #initialization }
ZoaArticleViewer >> updateArticle [
	article
		ifNotNil: [ tags items: self currentTags.
			authors items: self currentAuthors.
			data items: article data associations.
			view items: self currentBriefs ]
]
