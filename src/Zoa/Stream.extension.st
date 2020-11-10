Extension { #name : #Stream }

{ #category : #'*Zoa' }
Stream >> newLine [
	
	self nextPutAll: OSPlatform current lineEnding
]
