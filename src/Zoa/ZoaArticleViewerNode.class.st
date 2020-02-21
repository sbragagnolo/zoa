"
Grafoscopio extention for the UI 
"
Class {
	#name : #ZoaArticleViewerNode,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Zoa-Grafoscopio'
}

{ #category : #accessing }
ZoaArticleViewerNode >> asTreeNodePresenter [
	| node | 
	node := TreeNodePresenter new.
	node
		hasChildren: [ false ];
		children: [ {}];
		content: self.
	^ node
]

{ #category : #accessing }
ZoaArticleViewerNode >> content [
	self shouldBeImplemented.
]

{ #category : #accessing }
ZoaArticleViewerNode >> header [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> openIn: aGrafoscopioNewNotebook [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
ZoaArticleViewerNode >> parent: aZoaArticleNode [ 
	parent := aZoaArticleNode 
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> specModelClass [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> title [
	^ 'Viewer'
]
