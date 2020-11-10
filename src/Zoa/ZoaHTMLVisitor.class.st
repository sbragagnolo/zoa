"
I am an abstract HTML visitor. 
I do define some basic visiting behaviour. Im linked to a loader and an article. 
"
Class {
	#name : #ZoaHTMLVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'article',
		'loader'
	],
	#category : #'Zoa-Loader'
}

{ #category : #visiting }
ZoaHTMLVisitor >> addReferenceFrom: from to: to [

	| ref |
	ref := ZoaArticleArticleReference new.
	ref
		fromReference: from;
		toReference: to.
	article addReference: ref.
	^ ref
]

{ #category : #accessing }
ZoaHTMLVisitor >> article: anArticle [
	article := anArticle 
]

{ #category : #visiting }
ZoaHTMLVisitor >> detectHrefToArticle: anElement [

	| href |
	href := (self hrefsFor: anElement) select: [ :s | s beginsWith: s ].
	^ href
		  detect: [ :d | self hasDoi: d ]
		  ifFound: [ :h | self extractUrlFromHref: h ]
		  ifNone: [ 
			  href
				  detect: [ :d | self isUrlToResearchEngine: d ]
				  ifNone: [ nil] ]
]

{ #category : #'as yet unclassified' }
ZoaHTMLVisitor >> detectNode: aXMLElement class: aString [ 
	| vis | 
	vis := ZoaClassDetectorVisitor new.
	vis search: aString. 
	aXMLElement acceptNodeVisitor: vis.
	^ vis refs
]

{ #category : #accessing }
ZoaHTMLVisitor >> detectStringElement: aNode [

	| vis |
	vis := ZoaStringDetectVisitor new.
	aNode acceptNodeVisitor: vis.
	^ vis strings
		  collect: [ :s | s trimBoth ]
		  thenReject: [ :s | s isEmpty ]
]

{ #category : #testing }
ZoaHTMLVisitor >> element: anElement hasClass: aClass [

	^ (anElement attributeAt: 'class' ifAbsent: '') includesSubstring:
		  aClass
]

{ #category : #testing }
ZoaHTMLVisitor >> element: anElement hasId: anId [

	^ (anElement attributeAt: 'id' ifAbsent: '') includesSubstring: anId
]

{ #category : #testing }
ZoaHTMLVisitor >> element: anElement isType: aTypename [

	^ anElement name = aTypename
]

{ #category : #testing }
ZoaHTMLVisitor >> element: anElement isType: aTypename andClass: aClass [

	^ anElement name = aTypename and: [ 
		  self element: anElement hasClass: aClass ]
]

{ #category : #testing }
ZoaHTMLVisitor >> element: anElement isType: aTypename andClasses: classes [

	^ anElement name = aTypename and: [ 
		  classes allSatisfy: [ :cl | self element: anElement hasClass: cl ] ]
]

{ #category : #testing }
ZoaHTMLVisitor >> extractUrlFromHref: aString [

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
ZoaHTMLVisitor >> hasDoi: aString [
	^ {'/servlet/linkout?' . '/doi/' . 'doi.org' . 'doi=' }
		anySatisfy: [ :a | aString includesSubstring: a ]
]

{ #category : #visiting }
ZoaHTMLVisitor >> hrefsFor: anElement [
	| visitor |
	visitor := ZoaHrefExtractVisitor new.
	anElement acceptNodeVisitor: visitor.
	^ visitor hrefs
]

{ #category : #visiting }
ZoaHTMLVisitor >> initialize [
	super initialize.
	article := ZoaArticle new.
]

{ #category : #testing }
ZoaHTMLVisitor >> isUrlToResearchEngine: aString [

	^ { 'http' } anySatisfy: [ :s | 
		  (aString indexOfSubCollection: s) > 0 ]
]

{ #category : #accessing }
ZoaHTMLVisitor >> loader: aLoader [
	loader := aLoader
]

{ #category : #visiting }
ZoaHTMLVisitor >> processElement: anElement [
	self subclassResponsibility 
]

{ #category : #visiting }
ZoaHTMLVisitor >> visitElement: anElement [
	self processElement: anElement. 
	super visitElement: anElement.


]
