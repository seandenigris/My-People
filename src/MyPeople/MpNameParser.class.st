Class {
	#name : 'MpNameParser',
	#superclass : 'PP2CompositeNode',
	#instVars : [
		'token',
		'abbreviatableToken',
		'lastNameFirst',
		'firstNameFirst',
		'generational'
	],
	#category : 'MyPeople-Core'
}

{ #category : 'private' }
MpNameParser >> abbreviatable: aParser [
	^ (aParser, $. asPParser optional) flatten
]

{ #category : 'grammar' }
MpNameParser >> abbreviatableToken [
	^ self abbreviatable: token
]

{ #category : 'grammar' }
MpNameParser >> firstNameFirst [
	| middleName generationalPart lastName |
	generationalPart := (#space asPParser, generational) ==> #second.
	middleName := (#space asPParser, (generational not, abbreviatableToken) ==> #second) ==> #second.
	lastName := (#space asPParser, (generational not, token) ==> #second) ==> #second.
	^ (abbreviatableToken, ((middleName, lastName) / (nil asPParser, lastName)), generationalPart optional) ==> [ :nodes | 
		| result |
		result := MpName new
			lastName: nodes second second asLowercase capitalized;
			firstName: nodes first asLowercase capitalized;
			yourself.
		nodes second first ifNotNil: [ :mn | result middleName: (mn asLowercase capitalized trimRight: [ :c | c = $. ]) ].
		nodes third ifNotNil: [ :g | result generational: g asLowercase capitalized ].
		result ].
]

{ #category : 'grammar' }
MpNameParser >> generational [

	| generationalChoices |
	generationalChoices := 'JR' asPParser / 'SR' asPParser / 'Jr' asPParser / 'Sr' asPParser / 'III' asPParser / 'II' asPParser.
	^ self abbreviatable: generationalChoices
]

{ #category : 'grammar' }
MpNameParser >> lastNameFirst [

	| middleName generationalPart lastName firstName |
	generationalPart := (#space asPParser, generational) ==> #second.
	lastName := token.
	firstName := (#space asPParser, (generational not, abbreviatableToken) ==> #second) ==> #second.
	middleName := (#space asPParser, (generational not, abbreviatableToken) ==> #second) ==> #second.
	^ lastName, ',' asPParser, firstName, middleName optional, generationalPart optional ==> [ :nodes | | result |
		result := MpName new
			lastName: nodes first asLowercase capitalized;
			firstName: nodes third asLowercase capitalized;
			yourself.
		nodes fourth ifNotNil: [ :mn | result middleName: (mn asLowercase capitalized trimRight: [ :c | c = $. ]) ].
		nodes fifth ifNotNil: [ :g | result generational: g mpAsGenerational ].
		result ].
]

{ #category : 'accessing' }
MpNameParser >> start [
	^ self topLevelGrammars end
]

{ #category : 'grammar' }
MpNameParser >> token [

	^ (#letter asPParser | $' asPParser) plus flatten
]

{ #category : 'private' }
MpNameParser >> topLevelGrammars [
	^ lastNameFirst | firstNameFirst
]
