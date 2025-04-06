Class {
	#name : #MpUSAddressGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'number',
		'directional',
		'suffix',
		'streetName',
		'secondaryAddress',
		'parser'
	],
	#category : #MyPeople
}

{ #category : #grammar }
MpUSAddressGrammar >> directional [

	| result |
	result := PP2FailingNode instance.
	MpUSAddress directionalMap keysAndValuesDo: [ :canonForm :alts | 
		result := result / canonForm asString asPParser.
		alts do: [ :alt | 
			result := result / alt asPParser ] ].
	^ result
]

{ #category : #grammar }
MpUSAddressGrammar >> number [
	^ #digit asPParser plus flatten
]

{ #category : #grammar }
MpUSAddressGrammar >> parser [
	^ number , (#space asPParser , directional) optional , #space asPParser
		, streetName , #space asPParser , suffix
		, (#space asPParser, directional) optional
		, (#space asPParser, secondaryAddress flatten) optional
]

{ #category : #grammar }
MpUSAddressGrammar >> secondaryAddress [
	^ #any asPParser plus
]

{ #category : #grammar }
MpUSAddressGrammar >> start [
	^ self parser
]

{ #category : #grammar }
MpUSAddressGrammar >> streetName [
	^ suffix not , #word asPParser plus flatten
]

{ #category : #grammar }
MpUSAddressGrammar >> suffix [
	
	| result |
	result := PP2FailingNode instance.
	MpUSAddress streetSuffixMap keysAndValuesDo: [ :canonForm :alts | 
		result := result / canonForm asString asPParser.
		alts do: [ :alt | 
			result := result / alt asPParser ] ].
	^ result
]
