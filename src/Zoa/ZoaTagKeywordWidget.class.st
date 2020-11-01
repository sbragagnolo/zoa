Class {
	#name : #ZoaTagKeywordWidget,
	#superclass : #ZoaPresenter,
	#instVars : [
		'#tag => SpObservableSlot',
		'#nameLabel',
		'#openOnlineProfile',
		'#otherArticles'
	],
	#category : #'Zoa-UI'
}

{ #category : #specs }
ZoaTagKeywordWidget class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #nameLabel width: 150;
			"	add: #openOnlineProfile width: 30;
				add: #otherArticles width: 30;"
				yourself)
			height: 30;
		yourself
]

{ #category : #specs }
ZoaTagKeywordWidget class >> example [
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
ZoaTagKeywordWidget >> initialize [
	super initialize.
]

{ #category : #accessing }
ZoaTagKeywordWidget >> initializePrivateAnnouncements [
	super initializePrivateAnnouncements.
	self property: #tag whenChangedDo: [ self updateTag ]
]

{ #category : #initialization }
ZoaTagKeywordWidget >> initializeWidgets [
	nameLabel := self newLabel.
	openOnlineProfile := self newButton
		icon: (self iconNamed:#add ) ;
		yourself.
	otherArticles := self newButton
		icon:(self iconNamed:#add ) ;
		yourself
]

{ #category : #accessing }
ZoaTagKeywordWidget >> nameLabel [
	^ nameLabel
]

{ #category : #accessing }
ZoaTagKeywordWidget >> openOnlineProfile [
	^ openOnlineProfile
]

{ #category : #accessing }
ZoaTagKeywordWidget >> otherArticles [
	^ otherArticles
]

{ #category : #initialization }
ZoaTagKeywordWidget >> tag: aTag [
	tag := aTag
]

{ #category : #accessing }
ZoaTagKeywordWidget >> updateTag [
	nameLabel label: tag name.
]
