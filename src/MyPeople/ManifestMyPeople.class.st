"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestMyPeople',
	#superclass : 'PackageManifest',
	#category : 'MyPeople-Manifest'
}

{ #category : 'code-critics' }
ManifestMyPeople class >> ruleAssertEqualSignIntoAssertEqualsV1FalsePositive [
	^ #(#(#(#RGClassDescriptionDefinition #(#MpName)) #'2019-09-20T21:10:08.385171-04:00') )
]
