Class {
	#name : #ZoaSBUnresolvedArticle,
	#superclass : #Object,
	#instVars : [
		'url',
		'title'
	],
	#category : #'Zoa-Snowball'
}

{ #category : #accessing }
ZoaSBUnresolvedArticle >> getAllReferences [
	
	^ #()
]

{ #category : #microdown }
ZoaSBUnresolvedArticle >> microdownShortBriefUsing: aZoa [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: '#';
			  nextPutAll: self title;
			  newLine;
			  nextPutAll: self url asString;
			  newLine ]
]

{ #category : #accessing }
ZoaSBUnresolvedArticle >> title [
	
	^ title
]

{ #category : #accessing }
ZoaSBUnresolvedArticle >> title: aTitle [

	title := aTitle
]

{ #category : #accessing }
ZoaSBUnresolvedArticle >> url [
	^ url
]

{ #category : #accessing }
ZoaSBUnresolvedArticle >> url: anObject [
	url := anObject
]
