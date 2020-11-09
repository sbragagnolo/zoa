Class {
	#name : #ZoaReviewUI,
	#superclass : #ZoaPresenter,
	#instVars : [
		'tabs',
		'tags',
		'articles',
		'questions',
		'responses',
		'authors',
		'affiliations',
		'publisher',
		'query',
		'edition',
		'toolbar',
		'review',
		'preview',
		'abstractTags',
		'codifications',
		'keywords',
		'keywordsToArticle',
		'currentAuthors'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaReviewUI class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolbar height: self toolbarHeight * 1.5; 
		  add: #tabs
]

{ #category : #specs }
ZoaReviewUI class >> open [

	<example>
	| new |
	new := self new.
	new openWithSpec
		title: 'Review';
		extent: 1200 @ 750.
	^ new
]

{ #category : #specs }
ZoaReviewUI class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Zoa ) order: 1. 
	(aBuilder item: #'Reviewer')
		parent: #Zoa;
		action: [ self open openReview  ];
		order: 10;
		help: 'System browser to browse and edit code.';
		iconName: #checkBoxOff.
		
]

{ #category : #actions }
ZoaReviewUI >> addArticles [

	| dialog |
	review ifNil: [ ^ self ].
	dialog := ZoaArticleDialog new.
	dialog filterArticles: (review articles collect: [ :a | a article ]).
	dialog openDialogWithSpec
		okAction: [ 
			dialog chosenArticles do: [ :article | review addArticle: article ].
			self refresh ];
		title: 'Add articles into the review';
		yourself
]

{ #category : #actions }
ZoaReviewUI >> addBrief [
	| name |
	name := UIManager default
		        request: 'Name the brief'
		        initialAnswer: 'New'
		        title: ''.
	name ifNil: [ ^ self ].
	review addBrief: (ZoaBrief new
			 name: name;
			 yourself).
	zoa saveReview: review .
	edition items: review briefs
]

{ #category : #'data query' }
ZoaReviewUI >> amountOfArticlesByAffiliation: anAffiliation [

	^(review articles select: [ :a | a article affiliations includes: anAffiliation  ]) size
]

{ #category : #'data query' }
ZoaReviewUI >> amountOfArticlesPublishedBy: aPublisher [

	^ (review articles select: [ :a | a article publisher = aPublisher ])
		  size
]

{ #category : #initialization }
ZoaReviewUI >> articleContextMenuUsing: aZoa [

	^ self newMenu
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Inspect Article';
						  action: [ articles selectedItem article inspect ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Edit comments';
						  action: [ 
							  self openArticleViewerOn: articles selectedItem article ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'View in article database';
						  action: [ 
							  | viewer |
							  viewer := ZoaDatabaseExplorer new.
							  viewer focusOn: articles selectedItem article.
							  viewer openDialogWithSpec title:
									  articles selectedItem article title ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Read!';
						  action: [ zoa readArticle: articles selectedItem article ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Update state';
						  action: [ self updateStateArticle: articles selectedItem ] ] ];
		  yourself
]

{ #category : #'data query' }
ZoaReviewUI >> articlesExcludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   (anAuthor ids includesAny:
			    (ref article authorsReferences flatCollect: [ :r | r authorIds ])) 
			   and: [ ref isIncluded not ] ]) size
]

{ #category : #'data query' }
ZoaReviewUI >> articlesExcludedFromTag: aTag [

	^ (self keywordsToArticle at: aTag) select: [ :ref | 
		  ref isIncluded not ]
]

{ #category : #'data query' }
ZoaReviewUI >> articlesIncludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   (anAuthor ids includesAny:
			    (ref article authorsReferences flatCollect: [ :r | r authorIds ])) 
			   and: [ ref isIncluded ] ]) size
]

{ #category : #'data query' }
ZoaReviewUI >> articlesIncludedFromTag: aTag [
	^ (self keywordsToArticle at: aTag ) select: [ :ref | ref isIncluded ].

]

{ #category : #actions }
ZoaReviewUI >> askAndSaveIfNeeded [

	| save |
	save := UIManager default questionWithoutCancel:
		        'You are about to open an other review. Do you want to save  '
		        , review title , ' before closing? '.
	save ifTrue: [ zoa saveReview: review ]
]

{ #category : #'data query' }
ZoaReviewUI >> currentAuthors [

	| authorsIds |
	^ currentAuthors ifNil: [ 
		  authorsIds := review authorsReference flatCollect: [ :a | 
			                a authorIds ].
		  currentAuthors := zoa findAllAuthors select: [ :a | 
			                    authorsIds includesAny: a ids ] ]
]

{ #category : #'update and set' }
ZoaReviewUI >> currentKeywords [

	^ keywords ifNil: [ keywords := review keywords ]
]

{ #category : #actions }
ZoaReviewUI >> deleteReview [

	review ifNotNil: [ 
		(UIManager default questionWithoutCancel:
			 'Are you sure about deleting ' , review title , ' ? ') ifTrue: [ 
			(UIManager default questionWithoutCancel: 'Deadly sure?') ifTrue: [ 
				zoa delete: review.
				review := nil.
				self updateReview ] ] ]
]

{ #category : #actions }
ZoaReviewUI >> excludeArticleFromReview: anArticleRef [

	| reason codification |
	codifications := zoa findAllCodifications.
	codification := UIManager default
		                chooseFrom: codifications
		                values: codifications
		                title: 'Please enter the exclusion codification'.

	codification ifNil: [ ^ self ].
	reason := UIManager default
		          request: 'Please enter the reason to exclude this study.'
		          initialAnswer: (anArticleRef reason ifNil: [ '' ])
		          title: ''.
	reason ifNil: [ ^ self inform: 'Reason cannot be empty' ].

	anArticleRef included: false.
	anArticleRef reason: reason.
	anArticleRef codification: codification
]

{ #category : #accessing }
ZoaReviewUI >> firstAuthorName: aZoaReviewArticleReference [

	^ (self currentAuthors detect: [ :a | 
		   a ids includesAny:
			   aZoaReviewArticleReference firstAuthor authorIds ]) citeName
]

{ #category : #initialization }
ZoaReviewUI >> includeArticleIntoReview: anArticleRef [
	anArticleRef included: true. 
	
]

{ #category : #initialization }
ZoaReviewUI >> initializeNotebook [

	tabs
		addPage: (self newNotebookPageWith: tags and: 'Keywords');
		addPage:
			(self newNotebookPageWith: abstractTags and: 'Abstract Keywords');
		addPage: (self newNotebookPageWith: publisher and: 'Publishers');
		addPage:
			(self newNotebookPageWith: affiliations and: 'Affiliations');
		addPage: (self newNotebookPageWith: query and: 'Query');
		
		addPage: (self newNotebookPageWith: articles and: 'Articles');
		addPage: (self newNotebookPageWith: authors and: 'Authors');
		
		addPage: (self newNotebookPageWith: questions and: 'RQs');
		
		
		addPage: (self newNotebookPageWith: edition and: 'Edition');
		addPage: (self newNotebookPageWith: preview and: 'Preview')
]

{ #category : #initialization }
ZoaReviewUI >> initializeToolbar [

	toolbar
		addItemLeft: (self newToolbarButton
				 label: 'Refresh';
				 icon: (Smalltalk ui icons iconNamed: #glamorousRefresh);
				 action: [ self refresh ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Save';
				 icon: (Smalltalk ui icons iconNamed: #glamorousSave);
				 action: [ self saveReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'New';
				 icon: (Smalltalk ui icons iconNamed: #databaseAdd);
				 action: [ self newReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Open';
				 icon: (Smalltalk ui icons iconNamed: #open);
				 action: [ self openReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Delete';
				 icon: (Smalltalk ui icons iconNamed: #glamorousTrash);
				 action: [ self deleteReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Add Articles';
				 icon: (Smalltalk ui icons iconNamed: #add);
				 action: [ self addArticles ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Comment';
				 icon: (Smalltalk ui icons iconNamed: #announcement);
				 action: [ self addBrief ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 label: 'Export';
				 icon: (self iconNamed: #smallExport);
				 help: 'Export review';
				 action: [ self exportReview ];
				 yourself)
]

{ #category : #initialization }
ZoaReviewUI >> initializeWidgets [

	tabs := self newNotebook.
	toolbar := self newToolbar.
	preview := self newText.
	self initializeToolbar.
	tags := self newTagTable.
	abstractTags := self newAbstractKeywordsTable.
	query := self newQuery.
	articles := self newArticleTableUsing: zoa.
	authors := self newAuthorTable.
	publisher := self newPublisherTable.
	affiliations := self newAffiliationTable.
	edition := self newBriefsList.
	questions := self newQuestionsWidget. 

	self initializeNotebook
]

{ #category : #'data query' }
ZoaReviewUI >> keywordsToArticle [

	^ keywordsToArticle ifNil: [ 
		  keywordsToArticle := Dictionary new.
		  self currentKeywords do: [ :k | 
			  keywordsToArticle
				  at: k
				  put:
				  (review articles select: [ :ref | 
					   ref article keywords includes: k ]) ].
		  keywordsToArticle ]
]

{ #category : #initialization }
ZoaReviewUI >> newAbstractKeywordsTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a key < b key ];
		addColumn:
			((SpStringTableColumn title: '#' evaluated: [ :item | item value ])
				 width: 40;
				 beSortable;
				 yourself);
		addColumn:
			((SpStringTableColumn title: 'Word' evaluated: [ :item | item key ])
				 beSortable;
				 yourself);
		beResizable.
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newAffiliationTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a < b ];
		addColumn: ((SpStringTableColumn
				  title: '#'
				  evaluated: [ :item | self amountOfArticlesByAffiliation: item ])
				 width: 20;
				 beSortable;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Affiliation'
				  evaluated: [ :item | item ])
				 beSortable;
				 yourself);
		beResizable.

	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newArticleTableUsing: aZoa [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a title < b title ];
		addColumn: ((SpCheckBoxTableColumn
				  title: ' '
				  evaluated: [ :articleRef | articleRef isIncluded ])
				 onActivation: [ :articleRef | 
					 self includeArticleIntoReview: articleRef ];
				 onDeactivation: [ :articleRef | 
					 self excludeArticleFromReview: articleRef ];
				 width: 20;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'State'
				  evaluated: [ :item | item state ])
				 width: 50;
				 beSortable;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Date'
				  evaluated: [ :item | item date year asString ])
				 width: 50;
				 beSortable;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Author'
				  evaluated: [ :item | self firstAuthorName: item ])
				 width: 100;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Title'
				  evaluated: [ :item | item title ])
				 beSortable;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Exclusion Reason'
				  evaluated: [ :item | 
					  item isIncluded
						  ifTrue: [ '' ]
						  ifFalse: [ 
							  (item codification ifNil: [ 'NIL' ]) , ': ' , item reason ] ])
				 beSortable;
				 yourself);
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | 
			self openArticleViewerOn: selection selectedItem article ];
		beResizable.
	table contextMenu: (self articleContextMenuUsing: aZoa).
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newAuthorTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a fullName < b fullName ];

		addColumn: ((SpStringTableColumn
				  title: '(I) Included Articles'
				  evaluated: [ :item | self articlesIncludedFromAuthor: item ])
				 width: 30;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: '(X) Excluded Articles'
				  evaluated: [ :item | self articlesExcludedFromAuthor: item ])
				 width: 30;
				 yourself);
		addColumn: (SpStringTableColumn
				 title: 'Name'
				 evaluated: [ :item | item fullName asString ]);
		beResizable.
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newPublisherTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a < b ];
		addColumn: ((SpStringTableColumn
				  title: '#'
				  evaluated: [ :item | self amountOfArticlesPublishedBy: item ])
				 beSortable;
				 width: 20;
				 yourself);
		addColumn:
			((SpStringTableColumn title: 'Name' evaluated: [ :item | item ])
				 beSortable;
				 yourself) yourself;
		beResizable.

	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newQuery [

	| comp |
	comp := self newText autoAccept: true.
	comp whenSubmitDo: [ :text | review query: text ].

	^ comp
]

{ #category : #'instance creation' }
ZoaReviewUI >> newQuestionsWidget [
	^ self instantiate: ZoaReviewQuestionsWidget 
]

{ #category : #actions }
ZoaReviewUI >> newReview [

	| new title |
	title := UIManager default
		         request:
		         'Please, enter a title for the review project. You can change it later. '
		         initialAnswer: ''
		         title: 'Choose'.
	title ifNil: [ ^ self ].
	new := ZoaReview new.
	new title: title.

	self review: new
]

{ #category : #initialization }
ZoaReviewUI >> newTagTable [

	| table |
	table := self newTreeTable.

	table
		addColumn:
			((SpStringTableColumn title: '(I) Included' evaluated: [ :aTag | 
					  (aTag isKindOf: ZoaTag)
						  ifTrue: [ (self articlesIncludedFromTag: aTag) size ]
						  ifFalse: [ '' ] ])
				 width: 30;
				 yourself);
		addColumn:
			((SpStringTableColumn title: '(X) Excluded' evaluated: [ :aTag | 
					  (aTag isKindOf: ZoaTag)
						  ifTrue: [ (self articlesExcludedFromTag: aTag) size  ]
						  ifFalse: [ '' ] ])
				 width: 30;
				 yourself);
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
				ifTrue: [ 
					review articles
						select: [ :ref | ref article keywords includes: aTag ]
						thenCollect: [ :ref | ref article ] ]
				ifFalse: [ {  } ] ];
		beResizable.
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> openArticleViewerOn: article [

	| viewer |
	viewer := ZoaArticleViewer new.
	viewer article: article.
	viewer openDialogWithSpec title: article title
]

{ #category : #actions }
ZoaReviewUI >> openReview [

	| reviews opening |
	reviews := zoa findAllReviews.
	opening := UIManager default
		           chooseFrom: (reviews collect: [ :r | r title ])
		           values: reviews
		           title: 'Open review'.
	opening ifNotNil: [ self review: opening ]
]

{ #category : #'data query' }
ZoaReviewUI >> previewTextModel [
	
	^ MicroDownParser asText: (review microdownBriefUsing: zoa keywordsArticles: self keywordsToArticle )
]

{ #category : #'update and set' }
ZoaReviewUI >> refresh [

	keywords := nil.
	keywordsToArticle := nil.
	currentAuthors := nil .
	self updateReview
]

{ #category : #'update and set' }
ZoaReviewUI >> review: aZoaReview [ 
	review ifNotNil: [  
		self askAndSaveIfNeeded.	
	 ].
 	 review := aZoaReview.
	 self updateReview.
]

{ #category : #actions }
ZoaReviewUI >> saveReview [

	review ifNotNil: [ 
		zoa saveReview: review.
		self inform: 'The review has been saved in the DB..' ]
]

{ #category : #'update and set' }
ZoaReviewUI >> updateReview [

	review ifNil: [ 
		tags roots: {  }.
		abstractTags items: {  }.
		articles items: {  }.
		authors items: {  }.
		publisher items: {  }.
		affiliations items: {  }.
		edition items: {  }.
		query text: ''.
		preview text: ''.
		questions reset. 
		^ self ].
	questions review: review. 
	tags roots: self currentKeywords.
	articles items: review articles.
	authors items: self currentAuthors.
	query text: (review query ifNil: [ '' ]).
	preview text: self previewTextModel.
	publisher items: review publishers.
	affiliations items: review affiliations.
	abstractTags items: review abstractKeywords associations.
	edition items: review briefs
]

{ #category : #initialization }
ZoaReviewUI >> updateStateArticle: anArticleRef [

	| state |
	state := UIManager default
		         chooseFrom: zoa findAllArticleStates
		         values: zoa findAllArticleStates
		         title: 'New state'.
	state ifNotNil: [ anArticleRef state: state ]
]
