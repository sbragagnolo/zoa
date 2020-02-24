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

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> children [
	^ {  }
]

{ #category : #accessing }
ZoaArticleViewerNode >> header [
	^ 'viewer'
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> header: aString [ 

]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> openIn: aNotebook [
	aNotebook header text: 'Viewer'.
	aNotebook body: (aNotebook instantiate: ZoaArticleViewer).
	aNotebook body article: parent article.
	aNotebook body onArticleReloadClicked: [ 
		parent reload. 
		aNotebook body article: parent article.
	]
]

{ #category : #accessing }
ZoaArticleViewerNode >> parent: aZoaArticleNode [ 
	parent := aZoaArticleNode 
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> title [
	^ 'Viewer'
]

{ #category : #'as yet unclassified' }
ZoaArticleViewerNode >> updateEditionTimestamp [

]
