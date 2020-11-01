"
I am an abstract HTML visitor. 
I do define some basic visiting behaviour. Im linked to a loader and an article. 
"
Class {
	#name : #ZoaHTMLVisitor,
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'article',
		'loader',
		'zoaApi'
	],
	#category : #'Zoa-Loader'
}

{ #category : #'instance creation' }
ZoaHTMLVisitor class >> new [

	^ super new
		  zoaApi: Zoa current;
		  yourself
]

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

{ #category : #accessing }
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
ZoaHTMLVisitor >> zoaApi: aZoaApi [
	zoaApi := aZoaApi 
]
