Class {
	#name : #MpNameParser,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'token',
		'abbreviatableToken',
		'lastNameFirst',
		'firstNameFirst',
		'generational',
		'topLevelGrammars'
	],
	#category : #'MyPeople-Core'
}

{ #category : #examples }
MpNameParser class >> exampleDashedLastName [
	<gtExample>
	^ self
		given: []
		when: [ self parse: 'Rebecca Wirfs-Brock' ]
		then: [ :result | result isPetit2Success should equal: true ]
]

{ #category : #examples }
MpNameParser class >> exampleDontNormalizeCamelCase [
	<gtExample>
	^ self
		given: []
		when: [ self parse: 'LEONARDO daVinci' ]
		then: [ :result | 
			result firstName should equal: 'Leonardo'.
			result lastName should equal: 'daVinci' ]
]

{ #category : #private }
MpNameParser >> abbreviatable: aParser [
	^ (aParser, $. asPParser optional) flatten
]

{ #category : #grammar }
MpNameParser >> abbreviatableToken [
	^ self abbreviatable: token
]

{ #category : #grammar }
MpNameParser >> firstNameFirst [
	| middleName generationalPart lastName |
	generationalPart := (#space asPParser, generational) ==> #second.
	middleName := (#space asPParser, (generational not, abbreviatableToken) ==> #second) ==> #second.
	lastName := (#space asPParser, (generational not, token) ==> #second) ==> #second.
	^ (abbreviatableToken, ((middleName, lastName) / (nil asPParser, lastName)), generationalPart optional) ==> [ :nodes | 
		| result |
		result := MpName new
			lastName: nodes second second mpAsNameCase;
			firstName: nodes first mpAsNameCase;
			yourself.
		nodes second first ifNotNil: [ :mn | result middleName: (mn mpAsNameCase trimRight: [ :c | c = $. ]) ].
		nodes third ifNotNil: [ :g | result generational: g mpAsGenerational ].
		result ].
]

{ #category : #grammar }
MpNameParser >> generational [

	| generationalChoices |
	generationalChoices := 'JR' asPParser / 'SR' asPParser / 'Jr' asPParser / 'Sr' asPParser / 'III' asPParser / 'II' asPParser.
	^ self abbreviatable: generationalChoices
]

{ #category : #grammar }
MpNameParser >> lastNameFirst [

	| middleName generationalPart lastName firstName |
	generationalPart := (#space asPParser, generational) ==> #second.
	lastName := token.
	firstName := (#space asPParser optional, (generational not, abbreviatableToken) ==> #second) ==> #second.
	middleName := (#space asPParser, (generational not, abbreviatableToken) ==> #second) ==> #second.
	^ lastName, ',' asPParser, firstName, middleName optional, generationalPart optional ==> [ :nodes | | result |
		result := MpName new
			lastName: nodes first mpAsNameCase;
			firstName: nodes third mpAsNameCase;
			yourself.
		nodes fourth ifNotNil: [ :mn | result middleName: (mn mpAsNameCase trimRight: [ :c | c = $. ]) ].
		nodes fifth ifNotNil: [ :g | result generational: g mpAsGenerational ].
		result ].
]

{ #category : #accessing }
MpNameParser >> start [
	^ self topLevelGrammars end
]

{ #category : #grammar }
MpNameParser >> token [

	^ (#letter asPParser | $' asPParser | $- asPParser) plus flatten
]

{ #category : #private }
MpNameParser >> topLevelGrammars [
	^ lastNameFirst | firstNameFirst
]
