"
Grafoscopio extention for the UI 
"
Class {
	#name : #ZoaArticleViewer,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Zoa-Grafoscopio'
}

{ #category : #accessing }
ZoaArticleViewer >> asTreeNodePresenter [
	| node | 
	node := TreeNodePresenter new.
	node
		hasChildren: [ false ];
		children: [ {}];
		content: self.
	^ node
]

{ #category : #accessing }
ZoaArticleViewer >> content [
	self shouldBeImplemented.
]

{ #category : #accessing }
ZoaArticleViewer >> header [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
ZoaArticleViewer >> openIn: aGrafoscopioNewNotebook [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
ZoaArticleViewer >> parent: aZoaArticleNode [ 
	parent := aZoaArticleNode 
]

{ #category : #'as yet unclassified' }
ZoaArticleViewer >> specModelClass [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
ZoaArticleViewer >> title [
	^ 'Viewer'
]
