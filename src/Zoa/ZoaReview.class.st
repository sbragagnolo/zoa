Class {
	#name : #ZoaReview,
	#superclass : #Object,
	#instVars : [
		'query',
		'articles',
		'briefs',
		'title'
	],
	#category : #'Zoa-Model'
}

{ #category : #testing }
ZoaReview class >> isVoyageRoot [

	^ true
]

{ #category : #adding }
ZoaReview >> addArticle: anArticle [

	articles add: (ZoaReviewArticleReference new
			 article: anArticle;
			 yourself)
]

{ #category : #accessing }
ZoaReview >> affiliations [

	^ (articles flatCollect: [ :a | a article affiliations ]) asSet
		  asOrderedCollection
]

{ #category : #accessing }
ZoaReview >> articles [
	^ articles
]

{ #category : #accessing }
ZoaReview >> authors [
	^ (articles flatCollect: [ :a | a authors  ]) asSet asOrderedCollection sorted: [: x :y | 
			x fullName > y fullName 
		].
]

{ #category : #accessing }
ZoaReview >> briefs [
	^ briefs ifNil: [ briefs := OrderedCollection new ]
]

{ #category : #adding }
ZoaReview >> initialize [

	super initialize.
	articles := OrderedCollection new
]

{ #category : #accessing }
ZoaReview >> microdownBrief [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: '# Systematic Review: ';
			  nextPutAll: self title;
			  cr.
		  str
			  nextPutAll: '## Query ';
			  cr;
			  nextPutAll: self query;
			  cr.
		  str
			  nextPutAll: '## Affiliations ';
			  cr.
		  (self affiliations sort: [ :a :b | a < b ]) do: [ :aff | 
			  str
				  nextPutAll: '-';
				  nextPutAll: aff;
				  cr ].

		  str
			  nextPutAll: '## Keywords ';
			  cr.
		  (self tags sort: [ :a :b | a name < b name ]) do: [ :tag | 
			  str
				  nextPutAll: '-';
				  nextPutAll: tag name;
				  nextPutAll: '(';
				  nextPutAll: tag articles size asString;
				  nextPutAll: ')';
				  cr ].
		  str
			  nextPutAll: '## Included Articles';
			  cr.
		  articles select: [ :a | a isIncluded ] thenDo: [ :a | 
			  str
				  nextPutAll: '-';
				  nextPutAll: '(';
				  nextPutAll: a article cite;
				  nextPutAll: ')';
				  nextPutAll: a article title;
				  cr ].

		  str
			  nextPutAll: '## Excluded Articles';
			  cr.
		  ((articles reject: [ :a | a isIncluded ]) groupedBy: [ :a | 
			   a codification ]) keysAndValuesDo: [ :codification :arts | 
			  str nextPutAll: '### ' , codification; cr.
			  arts do: [ :a | 
				  str
					  nextPutAll: '-';
					  nextPutAll: '(';
					  nextPutAll: a article cite;
					  nextPutAll: ')';
					  nextPutAll: a article title;
					  cr ] ].
		
		 
		  self briefs do: [ :b | 
			  b includeInText ifTrue: [ 
				  str
					  nextPutAll: '##';
					  nextPutAll: b name;
					  cr;
					  nextPutAll: b text;
					  cr.

				  b tags ifNotEmpty: [ 
					  str
						  nextPutAll: '###Tags';
						  nextPutAll: (';' join: (b tags collect: [ :k | k name ]));
						  cr ] ] ] ]
]

{ #category : #accessing }
ZoaReview >> query [

	^ query ifNil: [ query := '' ]
]

{ #category : #accessing }
ZoaReview >> query: aCollection [ 
	query := aCollection asString 
]

{ #category : #accessing }
ZoaReview >> tags [
	^ (articles flatCollect: [ :a | a tags  ]) asSet asOrderedCollection sorted: [: x :y | 
			x name > y name 
		].
]

{ #category : #accessing }
ZoaReview >> title [
	^ title
]

{ #category : #accessing }
ZoaReview >> title: aString [ 
	title := aString
]
