"
Zoa visitor 
"
Class {
	#name : #ZoaVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'document',
		'zoa'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaVisitor >> addAuthor: anElement [
	| authorReference |
	authorReference := self resolveAuthorReferenceFor: anElement.
	document addAuthorReference: authorReference
]

{ #category : #visiting }
ZoaVisitor >> addReference: anElement [
	self assert: anElement nodes first name = 'span'.
	self assert: anElement nodes first nodes third name = 'span'.
	document addReference: (self createReferenceFromElement: anElement)
]

{ #category : #visiting }
ZoaVisitor >> createReferenceFromElement: anElement [
	| ref href |
	ref := ZoaArticleArticleReference new.
	ref text: anElement nodes first nodes first string.
	href := anElement nodes first nodes third nodes first
		attributeAt: 'href'.
	ref
		reference:
			((href beginsWith: 'https://dl.acm.org/doi/')
				ifTrue: [ href copyReplaceAll: 'https://dl.acm.org/doi/' with: '' ]
				ifFalse: [ (href beginsWith: '/servlet/linkout?')
						ifTrue: [ | stream |
							stream := href readStream.
							stream upToAll: '&key='.
							stream upToEnd ]
						ifFalse: [ self error: 'Unexpected case ' ] ]).
	^ ref
]

{ #category : #visiting }
ZoaVisitor >> ifIsAReference: anElement then: aBlock [
	^ (self isAReference: anElement)
		ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaVisitor >> ifIsAnAuthor: anElement then: aBlock [
	^ anElement name = 'li'
		and: [ (anElement attributeAt: 'class') includesSubstring: 'loa__item' ]
]

{ #category : #visiting }
ZoaVisitor >> initialize [
	super initialize.
	document := ZoaArticle new.
	zoa := Zoa new. 
]

{ #category : #visiting }
ZoaVisitor >> isAReference: anElement [
	^ [ anElement name = 'li'
		and: [ ((anElement attributeAt: 'class' ifAbsent: [ '' ])
				includesSubstring: 'references__item')
				and: [ (anElement attributeAt: 'id' ifAbsent: [ '' ]) beginsWith: 'ref-' ] ] ]
]

{ #category : #'as yet unclassified' }
ZoaVisitor >> isAbstract: anElement [
	^ anElement name = 'div'
		and: [ ((anElement attributeAt: 'class')
				includesSubstring: 'article__section')
				and: [ (anElement attributeAt: 'class')
						includesSubstring: 'article__abstract' ] ]
]

{ #category : #'as yet unclassified' }
ZoaVisitor >> isAbstract: anElement then: aBlockClosure [
	^ (self isAbstract: anElement)
		ifTrue: [ aBlockClosure value ]
]

{ #category : #visiting }
ZoaVisitor >> resolveAuthorReferenceFor: anElement [
	| author name lastname profile affiliation articleRef |
	name := ' '
		split: anElement first first first first first second string trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.
	affiliation := anElement second second first first string trimBoth.
	profile := anElement second second second attributeAt: 'href'.
	self assert: (profile beginsWith: '/profile/').
	profile := profile copyReplaceAll: '/profile/' with: ''.
	author := ZoaAuthor new.
	author name: name.
	author lastname: lastname.
	author acmId: profile.
	author := zoa findAuthorByExampleOrStore: author.
	articleRef := ZoaArticleAuthorReference new.
	articleRef affiliation: affiliation.
	author addArticle: articleRef.
	^ articleRef
]

{ #category : #visiting }
ZoaVisitor >> setAbstractUsing: anElement [
	self assert: anElement nodes second name = 'p'.
	document abstract: anElement nodes second string
]

{ #category : #visiting }
ZoaVisitor >> visitElement: anElement [
	super visitElement: anElement.
	self isAbstract: anElement then: [ self setAbstractUsing: anElement ].
	self ifIsAReference: anElement then: [ self addReference: anElement ].
	self ifIsAnAuthor: anElement then: [ self addAuthor: anElement ]
]
