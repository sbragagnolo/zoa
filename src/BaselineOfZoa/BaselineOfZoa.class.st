Class {
	#name : #BaselineOfZoa,
	#superclass : #BaselineOf,
	#category : #BaselineOfZoa
}

{ #category : #baselines }
BaselineOfZoa >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec baseline: 'XMLParserHTML' with: [ 
			spec repository:
				'github://pharo-contributions/XML-XMLParserHTML/src' ].
		spec
			baseline: 'Clap'
			with: [ spec repository: 'github://sbragagnolo/clap-st/src' ].
		spec baseline: 'Voyage' with: [ 
			spec
				repository: 'github://pharo-nosql/voyage';
				loads: #( 'mongo tests' 'memory tests' ) ].
		spec
			package: #Zoa
			with: [ spec requires: #( Clap XMLParserHTML Voyage ) ] ]
]
