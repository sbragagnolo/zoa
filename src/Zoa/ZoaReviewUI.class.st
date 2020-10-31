Class {
	#name : #ZoaReviewUI,
	#superclass : #SpPresenter,
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
		'preview'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaReviewUI class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolbar height: self toolbarHeight;
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

{ #category : #adding }
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

{ #category : #'as yet unclassified' }
ZoaReviewUI >> addBrief [

	| name |
	name := UIManager default
		        request: 'Name the brief'
		        initialAnswer: 'New'
		        title: ''.
	name ifNil: [ ^ self ].
	review briefs add: (ZoaBrief new
			 name: name;
			 yourself).
	self updateReview
]

{ #category : #initialization }
ZoaReviewUI >> amountOfArticlesByAffiliation: anAffiliation [

	^(review articles select: [ :a | a article affiliations includes: anAffiliation  ])
]

{ #category : #initialization }
ZoaReviewUI >> amountOfArticlesPublishedBy: aPublisher [

	^ (review articles select: [ :a | a article publisher = aPublisher ])
		  size
]

{ #category : #initialization }
ZoaReviewUI >> articleContextMenu [

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
									   { articles selectedItem article pdfFile fullName }) schedule ] ] ];
		  yourself
]

{ #category : #initialization }
ZoaReviewUI >> articlesExcludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   ((anAuthor articles collect: #article ) includes: ref article) and: [ ref isIncluded not ] ])
		  size
]

{ #category : #initialization }
ZoaReviewUI >> articlesExcludedFromTag: aTag [

	^ (review articles select: [ :ref | 
		   (aTag articles includes: ref article) and: [ ref isIncluded not ] ])
		  size
]

{ #category : #initialization }
ZoaReviewUI >> articlesIncludedFromAuthor: anAuthor [

	^ (review articles select: [ :ref | 
		   ((anAuthor articles collect: #article )includes: ref article) and: [ ref isIncluded ] ])
		  size
]

{ #category : #initialization }
ZoaReviewUI >> articlesIncludedFromTag: aTag [

	^ (review articles select: [ :ref | 
		   (aTag articles includes: ref article) and: [ ref isIncluded ] ])
		  size
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> askAndSaveIfNeeded [

	| save |
	save := UIManager default questionWithoutCancel:
		        'You are about to open an other review. Do you want to save  '
		        , review title , ' before closing? '.
	save ifTrue: [ Zoa current saveReview: review ]
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> deleteReview [

	review ifNotNil: [ 
		(UIManager default questionWithoutCancel:
			 'Are you sure about deleting ' , review title , ' ? ') ifTrue: [ 
			(UIManager default questionWithoutCancel: 'Deadly sure?') ifTrue: [ 
				Zoa current delete: review.
				review := nil.
				self updateReview  ] ] ]
]

{ #category : #initialization }
ZoaReviewUI >> excludeArticleFromReview: anArticleRef [

	| reason codification |
	codification := UIManager default
		                chooseFrom:
		                { #NotRelated. #Irrelevant. #TooShort. #GreyLiterature.
		                #Other }
		                values:
		                { #NotRelated. #Irrelevant. #TooShort. #GreyLiterature.
		                #Other }
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
ZoaReviewUI >> initializeWidgets [

	tabs := self newNotebook.

	toolbar := self newToolbar.
	preview := self newText.
	toolbar
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #glamorousSave);
				 action: [ self saveReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #databaseAdd);
				 action: [ self newReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #open);
				 action: [ self openReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #glamorousTrash);
				 action: [ self deleteReview ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #add);
				 action: [ self addArticles ];
				 yourself);
		addItemLeft: (self newToolbarButton
				 icon: (Smalltalk ui icons iconNamed: #announcement);
				 action: [ self addBrief ];
				 yourself).

	tags := self newTagTable.
	query := self newText autoAccept: true.
	query whenSubmitDo: [ :text | review query: text ].

	articles := self newArticleTable.
	authors := self newAuthorTable.
		publisher := self newPublisherTable.
	affiliations := self newAffiliationTable.
	edition := self newEditionArea.
	tabs
		addPage: (self newNotebookPageWith: tags and: 'Tags');
		addPage: (self newNotebookPageWith: query and: 'Query');
		addPage:
			(self newNotebookPageWith: articles and: 'Articles');
		addPage: (self newNotebookPageWith: authors and: 'Authors') ;
		addPage: (self newNotebookPageWith:publisher and: 'Publishers') ;
		addPage: (self newNotebookPageWith: affiliations and: 'Affiliations') ;
		addPage: (self newNotebookPageWith: edition and: 'Edition') ;
		addPage: (self newNotebookPageWith: preview and: 'Preview')   
]

{ #category : #initialization }
ZoaReviewUI >> newAffiliationTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a < b ];
		addColumn:
			((SpStringTableColumn title: 'Affiliation' evaluated: [ :item | item ])
				 width: 100;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: '#'
				  evaluated: [ :item | self amountOfArticlesByAffiliation: item ])
				 width: 20;
				 yourself);
		beResizable.

	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newArticleTable [

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
			 evaluated: [ :item | item isIncluded ifTrue: [ '' ] ifFalse: [ (item codification ifNil: ['NIL']), ': ', item reason ] ]);
		beResizable.
		table contextMenu: self articleContextMenu. 
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newAuthorTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a fullName < b fullName ];
		addColumn: (SpStringTableColumn
				 title: 'CiteName'
				 evaluated: [ :item | item citeName asString ]);
		addColumn: (SpStringTableColumn
				 title: 'Articles (DB)'
				 evaluated: [ :item | item articles size asString ]);
		addColumn: (SpStringTableColumn
				 title: 'Articles Included'
				 evaluated: [ :item | self articlesIncludedFromAuthor: item ]);
		addColumn: (SpStringTableColumn
				 title: 'Articles Excluded'
				 evaluated: [ :item | self articlesExcludedFromAuthor: item ]);
		beResizable.
	^ table
]

{ #category : #initialization }
ZoaReviewUI >> newEditionArea [

	^ self instantiate: SpComponentListPresenter
]

{ #category : #initialization }
ZoaReviewUI >> newNotebookPageWith: aProvider and: aTitle [

	^ self newNotebookPage
		  title: aTitle;
		  icon: (self iconNamed: #nautilusIcon);
		  presenterProvider: aProvider;
		  yourself
]

{ #category : #initialization }
ZoaReviewUI >> newPublisherTable [

	| table |
	table := self newTable.

	table
		sortingBlock: [ :a :b | a < b ];
		addColumn:
			((SpStringTableColumn title: 'Name' evaluated: [ :item | item ])
				 width: 100;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: '#'
				  evaluated: [ :item | self amountOfArticlesPublishedBy: item ])
				 width: 20;
				 yourself);
		beResizable.

	^ table
]

{ #category : #'instance creation' }
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
		addColumn: (SpCompositeTableColumn new
				 title: 'Name';
				 addColumn: ((SpImageTableColumn evaluated: #systemIcon)
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		addColumn:
			(SpStringTableColumn
				 title: 'Articles Included'
				 evaluated: [ :aTag | 
					 (aTag isKindOf: ZoaTag)
						 ifTrue: [ self articlesIncludedFromTag: aTag ]
						 ifFalse: [ '' ] ]);
		addColumn:
			(SpStringTableColumn
				 title: 'Articles Excluded'
				 evaluated: [ :aTag | 
					 (aTag isKindOf: ZoaTag)
						 ifTrue: [ self articlesExcludedFromTag: aTag ]
						 ifFalse: [ '' ] ]);
		roots: { Object };
		children: [ :aTag | 
			(aTag isKindOf: ZoaTag)
				ifTrue: [ aTag articles ]
				ifFalse: [ {  } ] ];
		beResizable.
	^ table
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> openReview [

	| reviews opening |
	reviews := Zoa current findAllReviews.
	opening := (UIManager default
			 chooseFrom: (reviews collect: [ :r | r title ])
			 values: reviews
			 title: 'Open review').
	opening ifNotNil: [ self review: opening ]
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> review: aZoaReview [ 
	review ifNotNil: [  
		self askAndSaveIfNeeded.	
	 ].
 	 review := aZoaReview.
	 self updateReview.
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> saveReview [

	review ifNotNil: [ 
		Zoa current saveReview: review.
		self updateReview ]
]

{ #category : #'as yet unclassified' }
ZoaReviewUI >> updateReview [

	| briefs |
	review ifNil: [ 
		tags items: {  }.
		articles items: {  }.
		authors items: {  }.
		publisher items: {  }.
		affiliations items: {  }.
		edition items: {  }.
		query text: ''.
		preview text: ''.
		^ self. 	
	 ].
	tags items: review tags.
	articles items: review articles.
	authors items: review authors.
	query text: (review query ifNil: [ '' ]).
	preview text: (MicroDownParser asText: review microdownBrief).
	publisher items:
		(review articles collect: [ :a | a article publisher ]) asSet
			asOrderedCollection.
	affiliations items: review affiliations.

	review briefs ifEmpty: [ 
		review briefs add: (ZoaBrief new
				 name: #Motivation;
				 yourself) ].
	briefs := review briefs collect: [ :b | 
		          ZoaBriefWidget new
			          brief: b;
			          onDelete: [ :br | review briefs remove: br ];
			          yourself ].

	edition items: briefs
]