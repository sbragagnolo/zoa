Class {
	#name : #ZoaIEEEVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'article',
		'references',
		'loading'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaIEEEVisitor >> article: anArtile [

	article := anArtile
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> detectStringElement: aNode [
	| vis |
	vis := ZoaStringDetectVisitor new.
	aNode acceptNodeVisitor:vis .
	^ vis strings collect: [ : s | s trimBoth] thenReject: [  : s | s isEmpty ]
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> extractUrlFromHref: aString [

	| upToAll |
	upToAll := '&key='.
	(aString includesSubstring: 'doi.org/') ifTrue: [ 
		upToAll := 'doi.org/' ].
	(aString includesSubstring: '/doi/') ifTrue: [ upToAll := '/doi/' ].
	(aString includesSubstring: 'doi=')ifTrue: [ upToAll :=  'doi=' ].
	^ aString readStream
		  upToAll: upToAll;
		  upToEnd
]

{ #category : #visiting }
ZoaIEEEVisitor >> hasDoi: aString [
	^ {'/servlet/linkout?' . '/doi/' . 'doi.org' . 'doi=' }
		anySatisfy: [ :a | aString includesSubstring: a ]
]

{ #category : #visiting }
ZoaIEEEVisitor >> hrefsFor: anElement [
	| visitor |
	visitor := ZoaHrefExtractVisitor new.
	anElement acceptNodeVisitor: visitor.
	^ visitor hrefs
]

{ #category : #visiting }
ZoaIEEEVisitor >> isUrlToResearchEngine: aString [

	^ { 'http' } anySatisfy: [ :s | 
		  (aString indexOfSubCollection: s) > 0 ]
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadCitation: element [
	| reference href detectedHref |
	
	reference := ZoaArticleArticleReference new.
	self assert:
		element nodes first nodes first nodes second name
		= 'span'.
	reference text: (self detectStringElement:
			 element nodes first nodes first nodes second ) first.

	href := (self hrefsFor: element) select: [ :s | s beginsWith: s ].

	detectedHref := href
		                detect: [ :d | self hasDoi: d ]
		                ifFound: [ :h | self extractUrlFromHref: h ]
		                ifNone: [ 
			                href
				                detect: [ :d | self isUrlToResearchEngine: d ]
				                ifNone: [ nil ] ].
	
detectedHref ifNil: [ ^ self  ].
	reference reference: detectedHref.
	reference to: article.
	article addReference: reference.
	^ reference
]

{ #category : #'as yet unclassified' }
ZoaIEEEVisitor >> loadReference: element [

	| reference href detectedHref |
	reference := ZoaArticleArticleReference new.
	self assert:
		element nodes first nodes first nodes first nodes second name
		= 'span'.
	reference text: (self detectStringElement:
			 element nodes first nodes first nodes first nodes second) first.

	href := (self hrefsFor: element) select: [ :s | s beginsWith: s ].

	detectedHref := href
		                detect: [ :d | self hasDoi: d ]
		                ifFound: [ :h | self extractUrlFromHref: h ]
		                ifNone: [ 
			                href
				                detect: [ :d | self isUrlToResearchEngine: d ]
				                ifNone: [ nil ] ].
	
detectedHref ifNil: [ ^ self  ].
	reference reference: detectedHref.
	reference from: article.
	article addReference: reference.
	^ reference
]

{ #category : #visiting }
ZoaIEEEVisitor >> processElement: anElement [

	anElement name = 'references' ifTrue: [ loading := #references ].
	anElement name = 'citations' ifTrue: [ loading := #citations ].
	((anElement attributeAt: 'class' ifAbsent:'') includesSubstring: 'reference-container') ifTrue: [ 
			loading = #references  ifTrue: [ self loadReference: anElement ].
			loading = #citations  ifTrue: [ self loadCitation: anElement ].
	 ] 
]

{ #category : #visiting }
ZoaIEEEVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
