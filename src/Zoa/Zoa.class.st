"
Entry point.
"
Class {
	#name : #Zoa,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'Zoa-API'
}

{ #category : #'as yet unclassified' }
Zoa class >> defaultFolder [
	^ (FileLocator home / '.zoa') ensureCreateDirectory 
]

{ #category : #accesing }
Zoa >> articles [
	^ (root / #database / #articles) ensureCreateDirectory
]

{ #category : #accesing }
Zoa >> authors [
	^ (root / #database / #authors) ensureCreateDirectory
]

{ #category : #read }
Zoa >> browse: aDocument [
	| url |
	url := aDocument pdfUrl
		ifNil: [ aDocument link
				ifNil: [ ^ self error: 'No url registered on this text' ] ].
	^ ([ :spec | 
	spec
		command: 'open';
		argument: url asString ] asOSTask
		future: TKTNewProcessTaskRunner new) waitForCompletion: 1 second
]

{ #category : #read }
Zoa >> browseDoi: aDoi [
	^ self browse: (self findByDoi: aDoi)
]

{ #category : #convenience }
Zoa >> doiToUrl: aDoi [
	| return url |
	return := STONJSON
		fromString:
			(ZnEasy
				get: ('https://doi.org/api/handles/{1}?type=URL' format: {aDoi}) asUrl)
				entity contents.
	return size < 3
		ifTrue: [ ^ self
				error: 'Unable to find ' , aDoi , ' Ensure the code is welformed' ].
	url := ((((return values at: 3) at: 1) at: #data) at: #value) asUrl.
	^ ZoaLoader formatUrl: url forDoi: aDoi
]

{ #category : #find }
Zoa >> findAllArticles [
	^ self findAllInDirectory: self articles
]

{ #category : #find }
Zoa >> findAllAuthors [
	^ self findAllInDirectory: self authors
]

{ #category : #find }
Zoa >> findAllInDirectory: aDirectory [
	| subdirectories |
	subdirectories := aDirectory entries
		select: #isDirectory
		thenCollect: [ :f | self findAllInDirectory: f asFileReference ].
	^ (aDirectory entries
		select: #isFile
		thenCollect: [ :f | self localLoad: f asFileReference ])
		, (subdirectories flatCollect: #yourself)
]

{ #category : #find }
Zoa >> findByDoi: aDoi [
	^ (self articles  / aDoi , 'doi') exists
		ifTrue: [ self localLoad: self articles / aDoi , 'doi' ]
		ifFalse: [ (self articles / aDoi , 'arx') exists
				ifTrue: [ self localLoad: self articles / aDoi , 'arx' ]
				ifFalse: [ self saveDoi: aDoi ] ]
]

{ #category : #command }
Zoa >> getPdf: doc [
	| entity  |
	doc pdfUrl ifNil: [ ^ self error: 'No url available for this text' ].
	doc pdf
		ifNil: [ entity := (ZnEasy get: doc pdfUrl) entity.
			entity contentType sub = 'html'
				ifTrue: [ doc pdf: (self manageRedirect: entity contents) ].
			entity contentType sub = 'pdf'
				ifTrue: [ doc pdf: entity contents ].
			self save: doc ]
]

{ #category : #command }
Zoa >> getPdfByDoi: aString [
	| doc |
	doc := self findByDoi: aString.
	self getPdf: doc
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
	^ (ZoaLoader loaderFor: anUrl host) new loadDocument: anUrl
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
Zoa >> read: aDocument [
	(#/ asFileReference / #tmp / aDocument hash asString , 'pdf') exists
		ifTrue:
			[ (#/ asFileReference / #tmp / aDocument hash asString , 'pdf') delete ].
	(#/ asFileReference / #tmp / aDocument hash asString , 'pdf')
		ensureCreateFile binaryWriteStream nextPutAll: aDocument pdfContent.
	^ ([ :spec | 
	spec
		command: 'open';
		argument: (#/ asFileReference / #tmp / aDocument hash asString , 'pdf') fullName ]
		asOSTask future: TKTNewProcessTaskRunner new)
		waitForCompletion: 2 seconds 
]

{ #category : #read }
Zoa >> readDoi: aDoi [
	^ self read: (self findByDoi: aDoi)
]

{ #category : #save }
Zoa >> save: doc [
	(STONWriter
		on:
		(self articles / doc doi
		,
			(doc isArxiv
				ifTrue: [ 'arx' ]
				ifFalse: [ 'doi' ])) ensureCreateFile writeStream)
		nextPut: doc;
		close
]

{ #category : #save }
Zoa >> saveDoi: aDoi [
	^ self saveUrl: (self doiToUrl: aDoi)
]

{ #category : #save }
Zoa >> saveUrl: aZnUrl [
	| doc |
	doc := self load: aZnUrl.
	self save: doc.
	^ doc 
]

{ #category : #read }
Zoa >> submit [
	| future |
	future := [ :spec | 
	spec
		command: 'bash';
		option: '-c';
		argument:
			('cd {1} && git add . && git commit -m" generated message" && git pull && git push '
				format: {root fullName}) ] asOSTask
		future: TKTNewProcessTaskRunner new.
	future waitForCompletion: 10 minutes.
	^ future isFailure
		ifTrue: [ ' Error during submition. Check your git repo' ]
		ifFalse: [ 'Submitted!' ]
]
