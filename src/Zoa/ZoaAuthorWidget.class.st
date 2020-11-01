"
Author brief
"
Class {
	#name : #ZoaAuthorWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#author => SpObservableSlot',
		'#nameLabel',
		'#openOnlineProfile',
		'#otherArticles'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaAuthorWidget class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #nameLabel width: 150;
				"add: #openOnlineProfile width: 30;
				add: #otherArticles width: 30;"
				yourself)
			height: 30;
		yourself
]

{ #category : #specs }
ZoaAuthorWidget class >> example [
	<example>
	self new
		author:
			(ZoaAuthor new
				name: 'Santiago';
				lastname: 'Bragagnolo';
				yourself);
		openWithSpec
]

{ #category : #initialization }
ZoaAuthorWidget >> author: anAuthor [
	author := anAuthor
]

{ #category : #accessing }
ZoaAuthorWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #author whenChangedDo: [ self updateAuthor ]
]

{ #category : #initialization }
ZoaAuthorWidget >> initializeWidgets [
	nameLabel := self newLabel.
	
]

{ #category : #accessing }
ZoaAuthorWidget >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
ZoaAuthorWidget >> openOnlineProfile [
	^ openOnlineProfile
]

{ #category : #accessing }
ZoaAuthorWidget >> otherArticles [
	^ otherArticles
]

{ #category : #accessing }
ZoaAuthorWidget >> updateAuthor [
	nameLabel label: author fullName.
]
