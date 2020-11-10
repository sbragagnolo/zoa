Class {
	#name : #ZoaWileyLoader,
	#superclass : #ZoaVisitorLoader,
	#category : #'Zoa-Loader'
}

{ #category : #api }
ZoaWileyLoader class >> formatUrl: aZnUrl forDoi: aDoi [
self halt. 
	^ ('https://dl.acm.org/doi/{1}' format: {aDoi}) asUrl
]

{ #category : #api }
ZoaWileyLoader class >> loads: aString [

	^ {'onlinelibrary.wiley.com' . 'doi.wiley.com'} includes: aString 
]

{ #category : #accessing }
ZoaWileyLoader class >> publisher [

	^ #Wiley
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> createVisitor [ 
	^ ZoaWileyVisitor new 
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> idFor: aZnUrl [
	
	self assert: ((aZnUrl host beginsWith:'doi'  )or:[ aZnUrl segments first = #doi.]).
	^ '/' join: (aZnUrl segments last: 2)
]

{ #category : #'as yet unclassified' }
ZoaWileyLoader >> referencesUrl: aDoi [

	^ ('https://onlinelibrary.wiley.com/action/ajaxShowEnhancedAbstract?ajax=true&doi='
	   , aDoi) asZnUrl
]
