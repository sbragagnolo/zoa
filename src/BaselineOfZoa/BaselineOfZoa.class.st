Class {
	#name : #BaselineOfZoa,
	#superclass : #BaselineOf,
	#category : #BaselineOfZoa
}

{ #category : #baselines }
BaselineOfZoa >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec
				baseline: 'XMLParserHTML'
				with: [ spec
						repository: 'github://pharo-contributions/XML-XMLParserHTML/src' ].
			spec
				baseline: 'TaskItShell'
				with: [ spec repository: 'github://pharo-contributions/taskit-shell/src' ].
			spec
				baseline: 'Clap'
				with: [ spec repository: 'github://sbragagnolo/clap-st/src' ].
			spec
				package: #Zoa
				with: [ spec requires: #(TaskItShell Clap XMLParserHTML) ] ]
]
