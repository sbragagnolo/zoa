"
Entry point.
"
Class {
	#name : #Zoa,
	#superclass : #Object,
	#category : #Zoa
}

{ #category : #'as yet unclassified' }
Zoa >> load: anUrl [
	^ (ZoaLoader loaderFor: anUrl host) new loadDocument: anUrl
]

{ #category : #'as yet unclassified' }
Zoa >> loadDoi: aDoi [
	| json |
	^ self
		load:
			(((((STONJSON
				fromString:
					(ZnEasy
						get:
							('https://doi.org/api/handles/{1}?type=URL' format: {aDoi}) asUrl)
						entity contents) values at: 3) at: 1) at: #data) at: #value)
				asUrl
]
