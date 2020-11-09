Class {
	#name : #ZoaReviewQuestionsWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'review',
		'questions',
		'addQuestion',
		'removeQuestion',
		'responses',
		'registerResults'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaReviewQuestionsWidget class >> defaultSpec [

	^ SpPanedLayout newVertical
		  position: 30 percent;
		  add: (SpBoxLayout newHorizontal add: (SpBoxLayout newVertical
						    add: #questions;
						    add: (SpBoxLayout newHorizontal
								     add: #addQuestion width: 100;
								     add: #removeQuestion width: 100)
						    expand: false));
		  add: (SpBoxLayout newHorizontal add: (SpBoxLayout newVertical
					    add: #responses;
					    add:
						    (SpBoxLayout newHorizontal add: #registerResults width: 100)
					    expand: false))
]

{ #category : #specs }
ZoaReviewQuestionsWidget class >> open [

	<example>
	| new |
	new := self new.
	new review:Zoa current findAllReviews first.
	new openWithSpec
		title: 'Review';
		extent: 696@405.
		
	^ new
]

{ #category : #accessing }
ZoaReviewQuestionsWidget >> addQuestion [

	| question |
	question := ZoaQuestion new.
	self openQuestion: question onAccept: [ :q | 
		review questions add: q.
		self updateWidget ]
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> initializeWidgets [

	super initializeWidgets.
	questions := self newQuestionTable .
	responses := self newResponsesTable. 
	addQuestion := self newButton
		               icon: (self iconNamed: #add);
		               action: [ self addQuestion ];
		               yourself.
	removeQuestion := self newButton
		                  icon: (self iconNamed: #remove);
		                  action: [ self removeSelectedQuestion ];
		                  yourself.
	registerResults := self newButton
		                   label: 'Register';
		                   action: [ self registerResultsForArticle ];
		                   yourself.
		
	

]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> newQuestionTable [

	^ self newTable
		  addColumn: ((SpStringTableColumn
				    title: #Question
				    evaluated: [ :item | item name , ' ' , item text ])
				   width: 100;
				   yourself);
		  addColumn: (SpStringTableColumn title: #Unit evaluated: #unit);
		  addColumn: (SpStringTableColumn
				   title: #Codifications
				   evaluated: [ :item | ', ' join: item codifications ]);
		  activateOnDoubleClick;
		  beResizable;
		  whenActivatedDo: [ :selection | 
			  self
				  openQuestion: selection selectedItem
				  onAccept: [ self updateWidget ] ] yourself
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> newResponsesTable [

	| table |
	table := self newTable.
	table beResizable.
	table addColumn: ((SpStringTableColumn
			  title: #Article
			  evaluated: [ :item | item title ])
			 width: 100;
			 yourself).
	review ifNil: [ ^ table ].
	review questions do: [ :q | 
		table addColumn: (((self selectColumnTypeForUnit: q unit)
				  title: q name
				  evaluated: [ :item | q readFrom: item responses ])
				 width: 50;
				 yourself) ].
	^ table
		  beResizable;
		  activateOnDoubleClick;
		  whenActivatedDo: [ :selection | 
			  self openResponse: selection selectedItem ];
		  yourself
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> openQuestion: aQuestion onAccept: anAcceptBlock [

	((self instantiate: ZoaQuestionWidget)
		 question: aQuestion;
		 onAccept: anAcceptBlock;
		 openWithSpec) title: 'Question Edition'
]

{ #category : #'as yet unclassified' }
ZoaReviewQuestionsWidget >> openResponse: aZoaReviewArticleReference [

	| elements |
	review questions ifEmpty: [ 
		self inform: 'There are not question to edit. '.
		^ self ].

	elements := review questions flatCollect: [ :q | 
		            { 
			            (self newLabel label: q name).
			            (self newTextInput text:
				             (q readFrom: aZoaReviewArticleReference responses) asString) } ].


	(self newStackedComponentWith: elements) openDialogWithSpec
		title: 'Responses for '
			, (aZoaReviewArticleReference title readStream next: 20);
		okAction: [ 
			elements pairsDo: [ :l :t | 
					| q |
					q := review questions detect: [ :qq | qq name = l label ].
					q write: t text into: aZoaReviewArticleReference responses ] ]
]

{ #category : #'as yet unclassified' }
ZoaReviewQuestionsWidget >> registerResultsForArticle [
	self openResponse: responses selectedItem 
]

{ #category : #removing }
ZoaReviewQuestionsWidget >> removeSelectedQuestion [
	review questions remove: questions selectedItem.
	self updateWidget 
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> reset [
 	review := nil. 
	questions items: {  }.
	responses items: {  }
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> review: aReview [

	review := aReview.
	self updateWidget
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> selectColumnTypeForUnit: aUnit [

	^ SpStringTableColumn
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> updateWidget [

	questions items: review questions.
	" We have one column per question + 1 of the article "
	(responses columns size = (review questions size  + 1)) ifFalse: [ 
		responses := self newResponsesTable.
		self update ].
	responses items: (review articles)
]
