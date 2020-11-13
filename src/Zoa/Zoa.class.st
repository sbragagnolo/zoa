"
Entry point.
"
Class {
	#name : #Zoa,
	#superclass : #Object,
	#instVars : [
		'root',
		'repository'
	],
	#classInstVars : [
		'zoa',
		'links'
	],
	#category : #'Zoa-API'
}

{ #category : #accessing }
Zoa class >> current [

	^ zoa ifNil: [ zoa := self host: 'localhost' database: 'zoa' ]
]

{ #category : #accessing }
Zoa class >> current: anObject [

	zoa := anObject
]

{ #category : #'as yet unclassified' }
Zoa class >> defaultFolder [
	^ (FileLocator home / '.zoa') ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
Zoa class >> host: aHost database: aDatabase [

	^ self new
		  repository: (VOMongoRepository host: aHost database: aDatabase);
		  yourself
]

{ #category : #'as yet unclassified' }
Zoa class >> memory [

	^ self new
		  repository: VOMemoryRepository new;
		  yourself
]

{ #category : #'as yet unclassified' }
Zoa class >> regenerate [

	| errors |
	self assert: zoa isNotNil.
	errors := Dictionary new.
	links := zoa findAllArticles asSet  collect: [ :a | 
		         a link asZnUrl -> a briefs ].
	zoa dropDatabase.
	links do: [ :assoc | 
		| article link briefs |
		link := assoc key.
		briefs := assoc value.
		link = 'http://ieeexplore.ieee.org/document/991506/' ifTrue: [ self halt ].
		[ 
		article := self current load: link.
		briefs do: [ :tb | article addBrief: tb ].
		self current saveArticle: article ]
			on: Error
			do: [ :err | errors at: links put: err ] ].
	errors ifNotEmpty: [ 
		self error: 'Errors happened during the regeneration ' ].
	links := nil
]

{ #category : #public }
Zoa >> allIncomingReferencesTo: anArticle [

	| allArticles |
	allArticles := self findAllArticles.
	^ (allArticles flatCollect: [ :a | a references ifNil: [ {  } ] ]) select: [ :ref | 
		  ref cites: anArticle ]
]

{ #category : #public }
Zoa >> allOutgoingReferencesFrom: anArticle [

	| allArticles |
	allArticles := self findAllArticles.
	^ (allArticles flatCollect: [ :a | a references ifNil:[{} ]]) select: [ :ref | 
		  ref citedBy: anArticle ]
]

{ #category : #public }
Zoa >> allReferencesRelatedWith: anArticle [

	| allArticles |
	allArticles := self findAllArticles.
	^ (allArticles flatCollect: [ :a | a references ]) select: [ :ref | 
		  ref isRelatedWith: anArticle ]
]

{ #category : #accesing }
Zoa >> articles [
	^ (root / #database / #articles) ensureCreateDirectory
]

{ #category : #accesing }
Zoa >> authors [
	^ (root / #database / #authors) ensureCreateDirectory
]

{ #category : #find }
Zoa >> beCurrent [

	Zoa current: self
]

{ #category : #public }
Zoa >> delete: aZoaArticle [

	self repository remove: aZoaArticle
]

{ #category : #convenience }
Zoa >> doiToUrl: aDoi [
	| return url |
	return := STONJSON
		fromString:
			(ZnEasy
				get: ('https://doi.org/api/handles/{1}?type=URL' format: {aDoi}) asUrl)
				entity contents.
	url := return size < 3
		ifTrue: [ (ZnEasy get: ('https://dl.acm.org/doi/{1}' format: {aDoi})) status = 200
				ifTrue: [ 'https://dl.acm.org/doi/{1}' format: {aDoi} ]
				ifFalse: [ ^ self
						error: 'Unable to find ' , aDoi , ' Ensure the code is welformed' ] ]
		ifFalse: [ ((((return values at: 3) at: 1) at: #data) at: #value) ].
	^ ZoaLoader formatUrl: url asUrl forDoi: aDoi
]

{ #category : #find }
Zoa >> dropDatabase [

	self repository dropDatabase.
	repository := nil.
	Zoa current = self ifTrue: [ Zoa current: nil ]
]

{ #category : #find }
Zoa >> emptyDatabase [
	self repository removeAll: ZoaArticle.
	self repository removeAll: ZoaArticleArticleReference .
	self repository removeAll: ZoaArticleAuthorReference .
	self repository removeAll: ZoaAuthor.
]

{ #category : #save }
Zoa >> exportArticle: anArticle to: aFolder [

	| export pdf brief ston |
	export := aFolder / anArticle fileBasename.
	pdf := self pdfFileFor: anArticle ifNotYetResolved: [ nil ].
	pdf ifNotNil: [ pdf copyTo: export ].
	brief := (export / 'brief.md')
		         ensureCreateFile;
		         writeStream.

	brief nextPutAll: (anArticle microdownBriefUsing: self).
	brief
		flush;
		close.
	ston := (export / (anArticle fileBasename , '.ston'))
		        ensureCreateFile;
		        writeStream.
	STON put: anArticle onStream: ston.
	ston
		flush;
		close
]

{ #category : #find }
Zoa >> findAllArticleReferences [
	^ (self repository findAllArticleReferences flatCollect: [ :a | a getAllReferences ]) asSet.
]

{ #category : #accesing }
Zoa >> findAllArticleStates [

	^ { #'WhatPaper?'. #Skimmed. #Reading .#Read.#QuicklyReviewed . #Reviewed. #Forgoten }
]

{ #category : #find }
Zoa >> findAllArticles [
	^ (self repository selectAll: ZoaArticle) asSet
]

{ #category : #find }
Zoa >> findAllArticlesWithKeyword: aKeyword [

	^ self findAllArticles select: [ :a | a keywords includes: aKeyword ]
]

{ #category : #find }
Zoa >> findAllAuthors [
	^ self repository selectAll: ZoaAuthor
]

{ #category : #accesing }
Zoa >> findAllCodifications [

	^ { #NotRelated. #Irrelevant. #TooShort. #GreyLiterature.
	  #Other }
]

{ #category : #accesing }
Zoa >> findAllResearchQuestionUnits [

	^ { #String. #Number. #Date }
]

{ #category : #'as yet unclassified' }
Zoa >> findAllReviews [
	^ self repository selectAll: ZoaReview
]

{ #category : #'as yet unclassified' }
Zoa >> findAllTags [
	^ (self repository selectAll: ZoaTag ) asSet 
]

{ #category : #find }
Zoa >> findArticleByDoi: aDoi [

	^ self repository selectOne: ZoaArticle where: [ :q | 
		  (q isKindOf: MQQuery)
			  ifTrue: [ (q fieldNamed: 'doi') = aDoi ]
			  ifFalse: [ q doi = aDoi ] ]
]

{ #category : #find }
Zoa >> findArticleByReference: aReference [
	^ self findArticleByDoi: aReference reference .
]

{ #category : #find }
Zoa >> findAuthorByExampleOrStore: anAuthor [

	^ (self findAuthorLike: anAuthor) ifNil: [ 
		  self saveAuthor: anAuthor.
		  anAuthor ]
]

{ #category : #find }
Zoa >> findAuthorByIds: aSet [ 

	^ self findAllAuthors detect: [ :a |a ids includesAny: aSet ]
]

{ #category : #find }
Zoa >> findAuthorLike: anOtherAuthor [
	^ self findAllAuthors
		detect: [ :a | a isLike: anOtherAuthor ]
		ifNone: [ nil ]
]

{ #category : #command }
Zoa >> getPdfFileForArticle: doc [

	| entity binary url ref |
	url := self privateGetUrlFor: doc.
	[ 
	entity := (ZnEasy get: url asZnUrl) entity.
	entity contentType sub = 'html' ifTrue: [ 
		binary := self manageRedirect: entity contents ].
	entity contentType sub = 'pdf' ifFalse: [ 
		doc pdfUrl: nil.
		self error: 'The url is either wrong or no longer valid' ].
	binary := entity bytes ]
		on: Error
		do: [ :e | 
			doc pdfUrl: nil.
			self error: 'The url is either wrong or no longer valid' ].
	ref := self articles / doc fileBasename , 'pdf'.
	ref
		ensureDelete;
		ensureCreateFile.
	ref binaryWriteStream
		nextPutAll: binary;
		flush;
		close.
	self saveArticle: doc.
	^ self articles / doc fileBasename , 'pdf'
]

{ #category : #public }
Zoa >> ifArticleIsLoaded: aReference then: aBlock ifNot: otherBlock [

	^ ({ 'ieeexplore.ieee.org'. 'scholar.google.com'. 'dl.acm.org'.
	   'researchgate.net'. 'academia.edu'. 'linkinghub.elsevier.com'.
	   'portal.acm.org'. 'arxiv.org'. 'sciencedirect.com'.
	   'link.springer.com' } anySatisfy: [ :s | 
		   (aReference indexOfSubCollection: s) > 0 ])
		  ifTrue: [ otherBlock value ]
		  ifFalse: [ 
			  (self findArticleByDoi: aReference)
				  ifNil: [ otherBlock  value ]
				  ifNotNil: [ :val | aBlock cull: val ] ]
]

{ #category : #read }
Zoa >> importAllReferencesRelatedWith: anArticle [

	anArticle references do: [ :r | 
		| to |
		[ 
		to := r to.
		self saveArticle: to ]
			on: Error
			do: [ :e | r to: nil ] ]
]

{ #category : #initialization }
Zoa >> initialize [ 
	super initialize.
	root := self class defaultFolder. 
]

{ #category : #list }
Zoa >> listAllArticles [
	^ self findAllArticles collect: #doi
]

{ #category : #load }
Zoa >> load: anUrl [

	^ (ZoaLoader loaderFor: anUrl host) new
		  zoa: self;
		  loadDocument: anUrl
]

{ #category : #public }
Zoa >> loadAndSaveArticle: anEntry [

	^ ({ 'ieeexplore.ieee.org'. 'scholar.google.com'. 'dl.acm.org'.
	   'researchgate.net'. 'academia.edu'. 'linkinghub.elsevier.com'.
	   'portal.acm.org'. 'arxiv.org'. 'sciencedirect.com'.
	   'link.springer.com' } anySatisfy: [ :s | 
		   (anEntry indexOfSubCollection: s) > 0 ])
		  ifTrue: [ self loadAndSaveArticleUrl: anEntry asZnUrl]
		  ifFalse: [ self loadAndSaveArticleDoi: anEntry ]
]

{ #category : #save }
Zoa >> loadAndSaveArticleDoi: aDoi [
	^ (self findArticleByDoi: aDoi)
		ifNil: [ self loadAndSaveArticleUrl: (self doiToUrl: aDoi) ]
]

{ #category : #save }
Zoa >> loadAndSaveArticleUrl: aZnUrl [
	| doc |
	doc := self load: aZnUrl.
	self saveArticle: doc.
	^ doc 
]

{ #category : #load }
Zoa >> loadDoi: aDoi [
	^ self load: (self doiToUrl: aDoi)
]

{ #category : #load }
Zoa >> localLoad: aFileReference [
	^ (STONReader on: aFileReference readStream) next
]

{ #category : #'as yet unclassified' }
Zoa >> manageRedirect: aString [
	| stream url return |
	stream := aString readStream.
	stream upToAll: 'window.location'.
	stream atEnd
		ifFalse: [ stream upToAll: '='.
			url := ((stream upTo: $;) copyReplaceAll: $' asString with: '')
				trimBoth ]
		ifTrue: [ stream reset upToAll: '<iframe'.
			stream upToAll: 'src="'.
			stream atEnd
				ifTrue: [ ^ self error: 'Unable to manage redirect' ].
			url := stream upToAll: '"' ].
	return := ZnEasy get: url asUrl.
	self assert: return contentType sub = 'pdf'.
	^ return contents
]

{ #category : #read }
Zoa >> pdfFileFor: doc [

	^ self pdfFileFor: doc ifNotYetResolved: [ self getPdfFileForArticle: doc ]
]

{ #category : #read }
Zoa >> pdfFileFor: doc ifNotYetResolved: aBlock [

	^ (self articles / doc fileBasename , 'pdf') exists
		  ifTrue: [ self articles / doc fileBasename , 'pdf' ]
		  ifFalse: [ aBlock cull:doc.  ]
]

{ #category : #command }
Zoa >> privateGetUrlFor: doc [

	doc pdfUrl ifNil: [ 
		doc pdfUrl: (UIManager default
				 request: 'Could you please give an url for the pdf?'
				 initialAnswer: doc link
				 title: 'Loading PDF') ].
	doc pdfUrl ifNil: [ self error: 'Cannot download pdf ' ].
	
	^ doc pdfUrl
]

{ #category : #accesing }
Zoa >> readArticle: anArticle [

	LibC system: 'open  ' , (anArticle pdfFileUsing: self) fullName
]

{ #category : #read }
Zoa >> repository [

	^ repository ifNil: [ 
		  repository := VOMongoRepository host: 'localhost' database: 'zoa' ]
]

{ #category : #read }
Zoa >> repository: aRepository [ 
	repository := aRepository. 

]

{ #category : #save }
Zoa >> saveArticle: doc [

	self assert: doc doi isNotNil.
	self findAllArticles
		detect: [ :a | 
			a doi = doc doi or: [ 
				a title = doc title and: [ 
					a firstAuthor = doc firstAuthor ] ] ]
		ifFound: [ :a | 
			a mergeWith: doc.
			self repository save: a ]
		ifNone: [ self repository save: doc ].


]

{ #category : #'as yet unclassified' }
Zoa >> saveAuthor: aZoaAuthor [
	self repository save: aZoaAuthor
]

{ #category : #save }
Zoa >> saveReview: aReview [
	self repository save: aReview 
]
