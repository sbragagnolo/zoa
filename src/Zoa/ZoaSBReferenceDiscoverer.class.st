Class {
	#name : #ZoaSBReferenceDiscoverer,
	#superclass : #Object,
	#instVars : [
		'articleQueue',
		'zoa'
	],
	#category : #'Zoa-Snowball'
}

{ #category : #accessing }
ZoaSBReferenceDiscoverer >> articleQueue [
	^ articleQueue
]

{ #category : #accessing }
ZoaSBReferenceDiscoverer >> currentArticle [
	
	self isEmpty ifTrue: [ ^ ZoaSBInvalidArticle new ].
	^ articleQueue first
]

{ #category : #importing }
ZoaSBReferenceDiscoverer >> importUrl: aZnUrl [ 
	"Import an article from a URL and push it at the end of the review queue"
	
	| article |
	article := zoa load: aZnUrl.
	articleQueue addLast: article.
	^ article
]

{ #category : #testing }
ZoaSBReferenceDiscoverer >> initialize [
	super initialize.
	articleQueue := OrderedCollection new
]

{ #category : #testing }
ZoaSBReferenceDiscoverer >> isEmpty [
	
	^ articleQueue isEmpty
]

{ #category : #queue }
ZoaSBReferenceDiscoverer >> queueReference: aZoaArticleArticleReference [ 

	| url article |
	url := aZoaArticleArticleReference toReference reference asZnUrl.
	article := [zoa load: url]
		on: Error do: [
			ZoaSBUnresolvedArticle new
				url: url;
				title: aZoaArticleArticleReference toReference title;
				yourself ].
	articleQueue addLast: article
]

{ #category : #accessing }
ZoaSBReferenceDiscoverer >> zoa: aZoa [ 
	
	zoa := aZoa
]
