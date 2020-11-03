Class {
	#name : #ZoaReviewUI,
	#superclass : #ZoaPresenter,
	#instVars : [
		'tabs',
		'tags',
		'articles',
		'authors',
		'affiliations',
		'publisher',
		'query',
		'edition',
		'toolbar',
		'review',
		'preview',
		'abstractTags',
		'codifications'
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
	new openWithSpec title: 'Review'.
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
	dialog filterArticles: (review articles collect: [: a |a article ]).
	dialog openDialogWithSpec
		okAction: [ dialog chosenArticles do: [:article | review addArticle: article ]. self updateReview ];
		cancelAction: [  ];
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
	self updateReview
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
							  | viewer |
							  viewer := ZoaArticleViewer new.
							  viewer article: articles selectedItem article.
							  viewer openDialogWithSpec ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'View in article database';
						  action: [ 
							  | viewer |
							  viewer := ZoaDatabaseExplorer new.
							  viewer focusOn: articles selectedItem article.
							  viewer openDialogWithSpec ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Read!';
						  action: [ 
							  (#open command arguments:
									   { (articles selectedItem article pdfFileUsing: aZoa)
										   fullName }) schedule ] ] ];
		  yourself
]

{ #category : #'data query' }
ZoaReviewUI >> articlesExcludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   ((anAuthor articles collect: #article ) includes: ref article) and: [ ref isIncluded not ] ])
		  size
]

{ #category : #'data query' }
ZoaReviewUI >> articlesExcludedFromTag: aTag [

	^ (review articles select: [ :ref | 
		   (aTag articles includes: ref article) and: [ ref isIncluded not ] ])
		  size 
]

{ #category : #'data query' }
ZoaReviewUI >> articlesIncludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   ((anAuthor articles collect: #article )includes: ref article) and: [ ref isIncluded ] ])
		  size
]

{ #category : #'data query' }
ZoaReviewUI >> articlesIncludedFromTag: aTag [

	^ (review articles select: [ :ref | 
		   (aTag articles includes: ref article) and: [ ref isIncluded ] ])
		  size +1
]

{ #category : #actions }
ZoaReviewUI >> askAndSaveIfNeeded [

	| save |
	save := UIManager default questionWithoutCancel:
		        'You are about to open an other review. Do you want to save  '
		        , review title , ' before closing? '.
	save ifTrue: [ zoa saveReview: review ]
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
		addPage: (self newNotebookPageWith: query and: 'Query');
		addPage: (self newNotebookPageWith: articles and: 'Articles');
		addPage: (self newNotebookPageWith: authors and: 'Authors');
		addPage: (self newNotebookPageWith: publisher and: 'Publishers');
		addPage:
			(self newNotebookPageWith: affiliations and: 'Affiliations');
		addPage: (self newNotebookPageWith: edition and: 'Edition');
		addPage: (self newNotebookPageWith: preview and: 'Preview')
]

{ #category : #initialization }
ZoaReviewUI >> initializeToolbar [

	toolbar
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
	self initializeNotebook
]

{ #category : #initialization }
ZoaReviewUI >> newAbstractKeywordsTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a key < b key ];
		addColumn: ((SpStringTableColumn
				  title: '#'
				  evaluated: [ :item | item value ])
				 width: 40;
				 yourself);
		addColumn:
		(SpStringTableColumn title: 'Word' evaluated: [ :item | item key ]);
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
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Affiliation'
				  evaluated: [ :item | item ])
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
		addColumn:
			(SpStringTableColumn
				 title: 'Exclusion Reason'
				 evaluated: [ :item | 
					 item isIncluded
						 ifTrue: [ '' ]
						 ifFalse: [ 
						 (item codification ifNil: [ 'NIL' ]) , ': ' , item reason ] ]);
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
				 width: 20;
				 yourself);
		addColumn:
			(SpStringTableColumn title: 'Name' evaluated: [ :item | item ])
				yourself;
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

	table	addColumn:
			((SpStringTableColumn
				 title: '(I) Included'
				 evaluated: [ :aTag | 
					 (aTag isKindOf: ZoaTag)
						 ifTrue: [ self articlesIncludedFromTag: aTag ]
						 ifFalse: [ '' ] ] ) width: 30; yourself) ;
		addColumn:
			((SpStringTableColumn
				 title: '(X) Excluded'
				 evaluated: [ :aTag | 
					 (aTag isKindOf: ZoaTag)
						 ifTrue: [ self articlesExcludedFromTag: aTag ]
						 ifFalse: [ '' ] ]) width: 30; yourself);
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

	^ MicroDownParser asText: (review microdownBriefUsing: zoa)
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
		self updateReview ]
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
		^ self ].
	tags roots: review tags.
	articles items: review articles.
	authors items: review authors.
	query text: (review query ifNil: [ '' ]).
	preview text: self previewTextModel.
	publisher items: review publishers.
	affiliations items: review affiliations.
	abstractTags items: review abstractKeywords associations.
	edition items: review briefs
]
