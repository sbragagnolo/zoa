"
Zoa visitor 
"
Class {
	#name : #ZoaACMVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'document',
		'zoa'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaACMVisitor >> addAuthor: anElement [
	| author name lastname profile affiliation articleRef |
	name := ' '
		split:
			(anElement nodes first nodes first nodes detect: [ :e | e isElement ])
				nodes first nodes first nodes second string trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.
	affiliation := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'p' ] ])
		ifNil: [ 'non known affiliation ' ]
		ifNotNil: [ :el | el nodes first string trimBoth ].
	profile := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'a' ] ])
		attributeAt: 'href'.
	self assert: (profile beginsWith: '/profile/').
	profile := profile copyReplaceAll: '/profile/' with: ''.
	author := ZoaAuthor new.
	author name: name.
	author lastname: lastname.
	author acmId: profile.
	(document authors noneSatisfy: [ :a | a isLike: author ])
		ifTrue: [ author := zoa findAuthorByExampleOrStore: author.
			articleRef := ZoaArticleAuthorReference new.
			articleRef affiliation: affiliation.
			articleRef author: author.
			author addArticle: articleRef.
			document addAuthorReference: articleRef ]
]

{ #category : #visiting }
ZoaACMVisitor >> addReference: anElement [
	self assert: anElement nodes first name = 'span'.
	
	document addReference: (self createReferenceFromElement: anElement)
]

{ #category : #accessing }
ZoaACMVisitor >> article: aZoaArticle [ 
	document := aZoaArticle
]

{ #category : #visiting }
ZoaACMVisitor >> createReferenceFromElement: anElement [
	| ref href |
	ref := ZoaArticleArticleReference new.
	ref text: anElement nodes first nodes first string.
	href := ((anElement nodes first nodes allButFirst select:#isElement) detect: [ :a | 
					a nodes first ifNotNil: [ :n | n isElement and: [n includesAttribute: 'href'] ]
									  ifNil: [ false ] ]) nodes first attributeAt: 'href'.
	ref
		reference:
			((href beginsWith: 'https://dl.acm.org/doi/')
				ifTrue: [ href copyReplaceAll: 'https://dl.acm.org/doi/' with: '' ]
				ifFalse: [ (href beginsWith: '/servlet/linkout?')
						ifTrue: [ | stream |
							stream := href readStream.
							stream upToAll: '&key='.
							stream upToEnd ]
						ifFalse: [ (href beginsWith: 'http://scholar.google.com/')
								ifTrue: [ href ]
								ifFalse: [ self error: 'Unexpected case' ] ] ]).
	^ ref
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAReference: anElement then: aBlock [
	^ (self isAReference: anElement)
		ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> ifIsAnAuthor: anElement then: aBlock [
	^( anElement name = 'li'
		and: [ (anElement attributeAt: 'class') = 'loa__item' ]) ifTrue: [ aBlock value ]
]

{ #category : #visiting }
ZoaACMVisitor >> initialize [
	super initialize.
	document := ZoaArticle new.
	zoa := Zoa new. 
]

{ #category : #visiting }
ZoaACMVisitor >> isAReference: anElement [
	^  anElement name = 'li'
		and: [ ((anElement attributeAt: 'class' ifAbsent: [ '' ])
				includesSubstring: 'references__item')
				and: [ (anElement attributeAt: 'id' ifAbsent: [ '' ]) beginsWith: 'ref-' ] ] 
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> isAbstract: anElement [
	^ anElement name = 'div'
		and: [ ((anElement attributeAt: 'class')
				includesSubstring: 'article__section')
				and: [ (anElement attributeAt: 'class')
						includesSubstring: 'article__abstract' ] ]
]

{ #category : #'as yet unclassified' }
ZoaACMVisitor >> isAbstract: anElement then: aBlockClosure [
	^ (self isAbstract: anElement)
		ifTrue: [ aBlockClosure value ]
]

{ #category : #visiting }
ZoaACMVisitor >> resolveAuthorReferenceFor: anElement [
	| author name lastname profile affiliation articleRef |
	name := ' '
		split:
			(anElement nodes first nodes first nodes detect: [ :e | e isElement ])
				nodes first nodes first nodes second string trimBoth.
	lastname := name last.
	name := ' ' join: name allButLast.
	affiliation := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'p' ] ]) nodes
		first string trimBoth.
	profile := ((anElement nodes second nodes
		detect: [ :e | 
			e isElement
				and: [ (e attributeAt: 'class') includesSubstring: 'info__body' ] ])
		nodes detect: [ :e | e isElement and: [ e name = 'a' ] ])  attributeAt: 'href'.
	self assert: (profile beginsWith: '/profile/').
	profile := profile copyReplaceAll: '/profile/' with: ''.
	author := ZoaAuthor new.
	author name: name.
	author lastname: lastname.
	author acmId: profile.
	author := zoa findAuthorByExampleOrStore: author.
	articleRef := ZoaArticleAuthorReference new.
	articleRef affiliation: affiliation.
	articleRef author: author.
	author addArticle: articleRef.
	^ articleRef
]

{ #category : #visiting }
ZoaACMVisitor >> setAbstractUsing: anElement [
	self assert: (anElement nodes second name = 'p' or: [anElement nodes second nodes first nodes first name = 'p']) .
	anElement nodes second name = 'p' ifTrue: [
		document abstract: anElement nodes second nodes first string
	] ifFalse: [
	   anElement nodes second nodes first nodes first nodes first string 
	]
]

{ #category : #visiting }
ZoaACMVisitor >> visitElement: anElement [
	super visitElement: anElement.
	self isAbstract: anElement then: [ self setAbstractUsing: anElement ].
	self ifIsAReference: anElement then: [ self addReference: anElement ].
	self ifIsAnAuthor: anElement then: [ self addAuthor: anElement ]
]
