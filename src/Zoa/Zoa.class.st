"
Entry point.
"
Class {
	#name : #Zoa,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #Zoa
}

{ #category : #'as yet unclassified' }
Zoa class >> defaultFolder [
	^ (FileLocator home / '.zoa') ensureCreateDirectory 
]

{ #category : #accesing }
Zoa >> documents [
	^ root / #database 
]

{ #category : #convenience }
Zoa >> doiToUrl: aDoi [
	| return |
	return := STONJSON
		fromString:
			(ZnEasy
				get: ('https://doi.org/api/handles/{1}?type=URL' format: {aDoi}) asUrl)
				entity contents.
	return size < 3
		ifTrue: [ ^ self
				error: 'Unable to find ' , aDoi , ' Ensure the code is welformed' ].
	^ ((((return values at: 3) at: 1) at: #data) at: #value) asUrl
]

{ #category : #find }
Zoa >> findAll [
	^ self findAllInDirectory: self documents
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
Zoa >> findByAuthor: anAuthor [
	^ self findByCollection: #authors value: anAuthor
]

{ #category : #find }
Zoa >> findByCollection: anAccessor value: aValue [
	^ self findAll
		select: [ :doc | 
			(doc perform: anAccessor)
				anySatisfy: [ :v | 
					(v includesSubstring: aValue caseSensitive: false)
						or: [ (aValue includesSubstring: v caseSensitive: false)
								or: [ (v alike: aValue) > aValue size ] ] ] ]
]

{ #category : #find }
Zoa >> findByDoi: aDoi [
	^ (self documents / aDoi , 'doi') exists
		ifTrue: [ self localLoad: self documents / aDoi , 'doi' ]
		ifFalse: [ (self documents / aDoi , 'arx') exists
				ifTrue: [ self localLoad: self documents / aDoi , 'arx' ]
				ifFalse: [ self saveDoi: aDoi ] ]
]

{ #category : #find }
Zoa >> findByKeyword: aKeyword [
	^ self findByCollection: #keywords value: aKeyword
]

{ #category : #find }
Zoa >> findByTag: aKeyword [
	^ self findByCollection: #tags value: aKeyword
]

{ #category : #command }
Zoa >> getPdf: aString [
	| doc |
	doc := self findByDoi: aString.
	doc pdf: (ZnEasy get: doc pdfUrl) entity contents.
	self save: doc
]

{ #category : #initialization }
Zoa >> initialize [ 
	super initialize.
	root := Zoa defaultFolder. 
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
Zoa >> localLoad:aFileReference [
	^ (STONReader on: aFileReference readStream ) next
]

{ #category : #read }
Zoa >> read: aDocument [
	(#/ asFileReference / #tmp / aDocument hash asString , 'pdf')
		ensureCreateFile binaryWriteStream nextPutAll: aDocument pdfContent.
	^ [ :spec | 
	spec
		command: 'open';
		argument: (#/ asFileReference / #tmp / aDocument hash asString , 'pdf') fullName ]
		asOSTask future waitForCompletion: 1 minute
]

{ #category : #read }
Zoa >> readAll: anArray [
	anArray do: [ :d | self read: d ]
]

{ #category : #read }
Zoa >> readDoi: aDoi [
	^ self read: (self findByDoi: aDoi)
]

{ #category : #save }
Zoa >> save: doc [
	(STONWriter
		on:
		(self documents / doc doi
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
