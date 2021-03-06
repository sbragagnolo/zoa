Class {
	#name : #ZoaArticleMetadata,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#article => SpObservableSlot',
		'#title',
		'#date',
		'#doi',
		'#authors',
		'#keywords',
		'#abstract',
		'#metadata',
		'#link',
		'#publisher',
		'#titleLabel',
		'#dateLabel',
		'#doiLabel',
		'#authorsLabel',
		'#keywordsLabel',
		'#abstractLabel',
		'#metadataLabel',
		'#linkLabel',
		'#publisherLabel',
		'#toolbar'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaArticleMetadata class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #toolbar height: self toolbarHeight *1.5;
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #titleLabel expand: false fill: false padding: 0;
						    add: #title expand: false fill: false padding: 0);
				   add: (SpBoxLayout newVertical
						    add: #doiLabel expand: false fill: false padding: 0 ;
						    add: #doi expand: false fill: false padding: 0))height: 50 ;
		add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #dateLabel expand: false fill: false padding: 0;
						    add: #date expand: false fill: false padding: 0);
				   add: (SpBoxLayout newVertical
						    add: #linkLabel  expand: false fill: false padding: 0;
						    add: #link expand: false fill: false padding: 0);
				   add: (SpBoxLayout newVertical
						    add: #publisherLabel expand: false fill: false padding: 0;
						    add: #publisher expand: false fill: false padding: 0)) height: 50 ;
		  add: #abstractLabel  expand: false ;
		  add: #abstract;
		 
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #keywordsLabel expand: false  ;
						    add: #keywords);
				   add: (SpBoxLayout newVertical
						    add: #authorsLabel expand: false ;
						    add: #authors )) expand: true fill: true padding: 0;
		  add: #metadataLabel expand: false ;
		  add: #metadata  expand: true fill: true  padding: 0
]

{ #category : #specs }
ZoaArticleMetadata class >> defaultSpec2 [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #titleLabel;
						    add: #title);
				   add: (SpBoxLayout newVertical
						    add: #doiLabel;
						    add: #doi));
		  add: #abstractLabel;
		  add: #abstract height: 100;
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #dateLabel;
						    add: #date);
				   add: (SpBoxLayout newVertical
						    add: #linkLabel;
						    add: #link);
				   add: (SpBoxLayout newVertical
						    add: #publisherLabel;
						    add: #publisher));
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #keywordsLabel;
						    add: #keywords);
				   add: (SpBoxLayout newVertical
						    add: #authorsLabel;
						    add: #authors)) height: 300;
		  add: #metadataLabel;
		  add: #metadata
]

{ #category : #specs }
ZoaArticleMetadata class >> defaultSpec3 [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #titleLabel;
						    add: #title);
				   add: (SpBoxLayout newVertical
						    add: #doiLabel;
						    add: #doi));
		  add: #abstractLabel;
		  add: #abstract height: 100;
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #dateLabel;
						    add: #date);
				   add: (SpBoxLayout newVertical
						    add: #linkLabel;
						    add: #link);
				   add: (SpBoxLayout newVertical
						    add: #publisherLabel;
						    add: #publisher));
		  add: (SpBoxLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: #keywordsLabel;
						    add: #keywords);
				   add: (SpBoxLayout newVertical
						    add: #authorsLabel;
						    add: #authors)) height: 300;
		  add: #metadataLabel;
		  add: #metadata
]

{ #category : #initialization }
ZoaArticleMetadata >> article: anArticle [

	article := anArticle
]

{ #category : #'data query' }
ZoaArticleMetadata >> currentAuthors [

	| authorsIds |
	authorsIds := article authorsReferences  flatCollect: [ :a | a authorIds ].
	^ zoa findAllAuthors select: [ :a | authorsIds includesAny: a ids ]
]

{ #category : #'data query' }
ZoaArticleMetadata >> currentKeywords [

	^ article keywords asOrderedCollection
]

{ #category : #initialization }
ZoaArticleMetadata >> extent [

	^ 720.0 @ 578.0
]

{ #category : #initialization }
ZoaArticleMetadata >> initializeLabels [

	titleLabel := self newLabel.
	titleLabel label: 'Title'.

	dateLabel := self newLabel.
	dateLabel label: 'Date'.

	doiLabel := self newLabel.
	doiLabel label: 'Doi'.

	authorsLabel := self newLabel.
	authorsLabel label: 'Authors'.

	keywordsLabel := self newLabel.
	keywordsLabel label: 'Keywords'.

	abstractLabel := self newLabel.
	abstractLabel label: 'Abstract'.

	metadataLabel := self newLabel.
	metadataLabel label: 'Metadata'.

	linkLabel := self newLabel.
	linkLabel label: 'Link'.

	publisherLabel := self newLabel.
	publisherLabel label: 'Publisher'
]

{ #category : #initialization }
ZoaArticleMetadata >> initializePrivateAnnouncements [

	super initializePrivateAnnouncements.
	self property: #article whenChangedDo: [ self updateArticle ]
]

{ #category : #initialization }
ZoaArticleMetadata >> initializeToolbar [

	toolbar addItemLeft: (self newToolbarButton
			 label: 'Save';
			 icon: (Smalltalk ui icons iconNamed: #glamorousSave);
			 action: [ self saveArticle  ];
			 yourself)
]

{ #category : #initialization }
ZoaArticleMetadata >> initializeWidgets [

	super initializeWidgets.
	self initializeLabels.
	toolbar := self newToolbar.
	self initializeToolbar.
	authors := self newAuthorList.
	abstract := self newText.
	keywords := self newTagsList.
	keywords onDelete: [ :t | article removeKeyword: t ].
	keywords onAdd: [ :t | article addKeyword: t ].
	authors onAdd: [ :a | self linkAuthorToArticle: a ].

	metadata := self newDataTable.
	title := self newTextInput.
	doi := self newTextInput.
	publisher := self newTextInput.
	link := self newTextInput.
	date := self newTextInput.
	self extent: 720.0 @ 578.0
	"	 #title . #date . #doi . #authors . #keywords . #abstract . #metadata . #link . #publisher"
]

{ #category : #initialization }
ZoaArticleMetadata >> initializeWindow: aWindow [
	super initializeWindow: aWindow. 
]

{ #category : #initialization }
ZoaArticleMetadata >> linkAuthorToArticle: author [

	| articleRef  |
	articleRef := ZoaArticleAuthorReference new.
	articleRef authorIds: author ids.
	author addArticle: articleRef.
	articleRef articleReference: (ZoaArticleReference new
			 reference: article doi;
			 title: article title;
			 yourself).
	article addAuthorReference: articleRef.
	zoa saveAuthor: author
]

{ #category : #initialization }
ZoaArticleMetadata >> newDataTable [

	^ self newTable
		  addColumn: (SpStringTableColumn evaluated: #key);
		  addColumn: (SpStringTableColumn evaluated: #value);
		  yourself
]

{ #category : #initialization }
ZoaArticleMetadata >> saveArticle [
	article date: date text asDate. 
	article publisher: publisher text. 
	article link: link text. 
	article title: title text.
	article abstract: abstract text.  
	
	zoa saveArticle: article 
]

{ #category : #initialization }
ZoaArticleMetadata >> updateArticle [

	abstract text: (article abstract ifNil: [ '' ]).
	keywords items: self currentKeywords.
	metadata items: article data associations.
	title text: article title.
	doi text: article doi.
	publisher text: article publisher.
	keywords items: article keywords asOrderedCollection.
	authors items: self currentAuthors. 
	date text: article date asString. 
	link text: article link asString.
]
