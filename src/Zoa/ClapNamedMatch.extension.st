Extension { #name : #ClapNamedMatch }

{ #category : #'*Zoa' }
ClapNamedMatch >> namedArgument [
	^ ClapNamedArgument fromKeyword: keyword
]
