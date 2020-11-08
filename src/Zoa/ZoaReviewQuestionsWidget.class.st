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

	^ SpBoxLayout newVertical
		  add: #questions;
		  add: (SpBoxLayout newHorizontal
				   add: #addQuestion width: 100;
				   add: #removeQuestion width: 100)
		  expand: false;
		  add: #responses;
		  add: (SpBoxLayout newHorizontal add: #registerResults width: 100)
		  expand: false
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
	review questions add: question.
	(self instantiate: ZoaQuestionWidget)
		question: question;
		openWithSpec
]

{ #category : #initialization }
ZoaReviewQuestionsWidget >> initializeWidgets [

	super initializeWidgets.
	questions := self newQuestionTable .
	responses := self newTable. 
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
		
		  addColumn: (SpStringTableColumn title: #Question evaluated: #text);
		  addColumn: (SpStringTableColumn title: #Unit evaluated: #unit);
		  yourself
]

{ #category : #removing }
ZoaReviewQuestionsWidget >> removeSelectedQuestion [
	review questions remove: questions selectedItem 
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
ZoaReviewQuestionsWidget >> updateWidget [
	questions items: review questions.
	responses items: (review articles collect: [ : a | a responses ])
]
