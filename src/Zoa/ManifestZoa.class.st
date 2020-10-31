"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestZoa,
	#superclass : #PackageManifest,
	#category : #'Zoa-Manifest'
}

{ #category : #'code-critics' }
ManifestZoa class >> ruleParseTreeLintRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Zoa)) #'2020-10-31T21:18:33.371859+01:00') )
]

{ #category : #'code-critics' }
ManifestZoa class >> ruleStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Zoa)) #'2020-10-31T21:18:39.873982+01:00') )
]
