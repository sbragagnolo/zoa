Extension { #name : #GrafoscopioNewNotebook }

{ #category : #'*Zoa' }
GrafoscopioNewNotebook >> importArticle2 [
	| input zoa document |
	input := UIManager default
		request: 'Enter DOI (Only the number) / or URL of the article to import. '
		initialAnswer: 'https://'.
	zoa := Zoa new.
	document := (input beginsWith: 'http')
		ifTrue: [ zoa saveUrl: input asUrl ]
		ifFalse: [ zoa saveDoi: input ].
	notebook addNode: document asGrafoscopioNode.
	self notebookContent: notebook.
]
