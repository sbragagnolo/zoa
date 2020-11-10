"
I represent a Google scholar visitor. I am here to detect the source of an article and delagate to the proper loader. 
"
Class {
	#name : #ZoaGoogleScholarVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'document',
		'references',
		'zoa'
	],
	#category : #'Zoa-Loader'
}

{ #category : #accessing }
ZoaGoogleScholarVisitor >> isAnArticleReference: anElement [
	^ anElement name = 'div' and: [ 
		 ( (anElement attributeAt: 'class' ifAbsent: [ '' ]) 
			  includesSubstring: 'gs_r gs_or gs_scl' ) and:[ anElement nodes size > 1 ] ]
]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarVisitor >> loadArticleReference: aXMLElement [
	| linksArea refs |
	linksArea := aXMLElement nodes second nodes first nodes.
	 refs  := linksArea select: [  : n | (n respondsTo:#name ) and: [ n name = 'a' ]].
	
	self assert: refs size = 1.
	self references add: (refs first attributeAt:
			   'href')
]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarVisitor >> loadDocument [

	references isEmptyOrNil ifTrue: [ 
		^ self error: 'The google scholar search leads no where' ].
	references size > 1 ifTrue: [ 
		| ref |
		ref := UIManager default
			       chooseFrom: references
			       values: references
			       title:
			       'Many references were found in the google scholar input. Please choose one'.
		ref ifNil: [ 
			^ self error:
				  'The google scholar search leads to too many relations! ' ].

		references := { ref } ].
	^ zoa load: references first asZnUrl
]

{ #category : #accessing }
ZoaGoogleScholarVisitor >> processElement: anElement [
	^ (self
		  isAnArticleReference: anElement)
		  ifTrue: [ self loadArticleReference: anElement ]
]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarVisitor >> references [ 
	^ references ifNil: [ references := OrderedCollection new ].
]

{ #category : #accessing }
ZoaGoogleScholarVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]

{ #category : #'as yet unclassified' }
ZoaGoogleScholarVisitor >> zoa: aZoa [	
	zoa := aZoa
]
