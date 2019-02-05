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
				baseline: 'TaskItShell'
				with: [ spec repository: 'github://sbragagnolo/TaskIt/src' ].
			spec
				baseline: 'Clap'
				with: [ spec repository: 'github://sbragagnolo/clap-st/src' ].
			spec package: #Zoa with: [ spec requires: #(TaskItShell Clap) ] ]
]
