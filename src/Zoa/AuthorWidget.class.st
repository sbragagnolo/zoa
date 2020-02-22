Class {
	#name : #AuthorWidget,
	#superclass : #ComposablePresenter,
	#instVars : [
		'author',
		'nameLabel',
		'openOnlineProfile',
		'otherArticles'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
AuthorWidget class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :r | 
			r
				add: #nameLabel ;
				add: #openOnlineProfile width: 20;
				add: #otherArticles width: 20 ] height: 30
]

{ #category : #initialization }
AuthorWidget >> author: anAuthor [
	author := anAuthor.
	nameLabel label: anAuthor fullName.
]

{ #category : #initialization }
AuthorWidget >> initializeWidgets [
	nameLabel := self newLabel.
	openOnlineProfile := self newButton
		icon: MendaIcons new tagAddIcon;
		yourself.
	otherArticles := self newButton
		icon: MendaIcons new tagAddIcon;
		yourself
]

{ #category : #accessing }
AuthorWidget >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
AuthorWidget >> openOnlineProfile [
	^ openOnlineProfile
]

{ #category : #accessing }
AuthorWidget >> otherArticles [
	^ otherArticles
]
