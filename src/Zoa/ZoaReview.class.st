"
I represent a systematic review of literature. 
I am related with a set of articles .
"
Class {
	#name : #ZoaReview,
	#superclass : #Object,
	#instVars : [
		'query',
		'articles',
		'briefs',
		'title',
		'id',
		'questions'
	],
	#category : #'Zoa-Model'
}

{ #category : #testing }
ZoaReview class >> isVoyageRoot [

	^ true
]

{ #category : #adding }
ZoaReview >> = anOtherReview [

	^ self species = anOtherReview species and: [ id = anOtherReview id ]
]

{ #category : #accessing }
ZoaReview >> abstractKeywords [

	^ (((((String space split: ((String space join:
			         ((self articles collect: [ :a | a article abstract ]) reject:#isNil thenCollect: [ 
				          :a | 
				          String space join:
					          (String space split: a asString asLowercase) asSet
						          asOrderedCollection ])) asLowercase select: [ :i | 
			        i isLetter or: [ i = Character space ] ])) select: [ :i | 
		      i size > 5 ]) groupedBy: [ :s | s asSymbol ]) associations 
		    collect: [ :ass | ass key -> ass value size ]) select: [ :ass | 
		   ass value > (self articles size / 3) ]) asDictionary
]

{ #category : #adding }
ZoaReview >> addArticle: anArticle [

	articles add: (ZoaReviewArticleReference new
			 article: anArticle;
			 yourself)
]

{ #category : #adding }
ZoaReview >> addBrief: aBrief [

	briefs add: aBrief.
	aBrief order: (aBrief order ifNil: [ briefs size ])
]

{ #category : #accessing }
ZoaReview >> affiliations [

	^ (articles flatCollect: [ :a | a article affiliations  ]) asSet
		  asOrderedCollection select:[: i | i isNotNil ] thenCollect: [ :a | a isString ifTrue: [ a ] ifFalse:[ a first] ]
]

{ #category : #accessing }
ZoaReview >> articles [
	^ articles
]

{ #category : #accessing }
ZoaReview >> authorsReference [
	^ (articles flatCollect: [ :a | a authorsReferences   ]) asSet asOrderedCollection 
	
	
]

{ #category : #accessing }
ZoaReview >> briefs [

	^ briefs
]

{ #category : #adding }
ZoaReview >> hash [

	^ id hash
]

{ #category : #adding }
ZoaReview >> id [

	^ id
]

{ #category : #adding }
ZoaReview >> initialize [

	super initialize.
	id := UUID new. 
	articles := OrderedCollection new.
	briefs := OrderedCollection new.
	
]

{ #category : #accessing }
ZoaReview >> keywords [
	^ (articles flatCollect: [ :a | a keywords  ]) asSet asOrderedCollection sorted: [: x :y | 
			x name > y name 
		].
]

{ #category : #reference }
ZoaReview >> microdownBriefUsing: aZoa [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: '# Systematic Review: ';
			  nextPutAll: self title;
			  cr.

		(  self briefs sorted: [ : a : b | a order < b order  ]) do: [ :b | 
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
						  cr ] ] ].

		  str
			  nextPutAll: '## Affiliations ';
			  cr.
		  (self affiliations sort: [ :a :b | a < b ]) do: [ :aff | 
			  str
				  nextPutAll: '-';
				  nextPutAll: aff;
				  cr ].

		  str
			  nextPutAll: '##Keywords ';
			  cr.
		  (self keywords sort: [ :a :b | a name < b name ]) do: [ :tag | 
			  str
				  nextPutAll: '-';
				  nextPutAll: tag name;
				  nextPutAll: '(';
				  nextPutAll: (aZoa findAllArticlesWithKeyword: tag) size asString;
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
			  str
				  nextPutAll: '### ' , codification;
				  cr.
			  arts do: [ :a | 
				  str
					  nextPutAll: '-';
					  nextPutAll: '(';
					  nextPutAll: a article cite;
					  nextPutAll: ')';
					  nextPutAll: a article title;
					  cr ] ] ]
]

{ #category : #reference }
ZoaReview >> microdownBriefUsing: aZoa keywordsArticles: aDictionaryKeyToArticles [

	^ String streamContents: [ :str | 
		  str
			  nextPutAll: '# Systematic Review: ';
			  nextPutAll: self title;
			  cr.

		  (self briefs sorted: [ :a :b | a order < b order ]) do: [ :b | 
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
						  cr ] ] ].

		  str
			  nextPutAll: '## Affiliations ';
			  cr.
		  (self affiliations sort: [ :a :b | a < b ]) do: [ :aff | 
			  str
				  nextPutAll: '-';
				  nextPutAll: aff;
				  cr ].

		  str
			  nextPutAll: '##Keywords ';
			  cr.
		  (self keywords sort: [ :a :b | a name < b name ]) do: [ :tag | 
			  str
				  nextPutAll: '-';
				  nextPutAll: tag name;
				  nextPutAll: '(';
				  nextPutAll: (aDictionaryKeyToArticles at: tag) size asString;
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
			  str
				  nextPutAll: '### ' , codification;
				  cr.
			  arts do: [ :a | 
				  str
					  nextPutAll: '-';
					  nextPutAll: '(';
					  nextPutAll: a article cite;
					  nextPutAll: ')';
					  nextPutAll: a article title;
					  cr ] ] ]
]

{ #category : #accessing }
ZoaReview >> publishers [

	^ (articles collect: [ :a | a article publisher ]) asSet
		  asOrderedCollection 
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
ZoaReview >> questions [
	^ questions ifNil: [ questions := OrderedCollection new ]
]

{ #category : #accessing }
ZoaReview >> title [
	^ title
]

{ #category : #accessing }
ZoaReview >> title: aString [ 
	title := aString
]
