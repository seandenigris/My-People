Class {
	#name : #MpName,
	#superclass : #Object,
	#instVars : [
		'firstName',
		'middleName',
		'lastName',
		'generational'
	],
	#category : 'MyPeople-Core'
}

{ #category : #'instance creation' }
MpName class >> fromString: aString [

	^ MpNameParser parse: aString onError: [ self error: 'Failed paring ', aString ]
]

{ #category : #testing }
MpName class >> isValidInput: aString [ 

	MpNameParser parse: aString onError: [ ^ false ].
	^ true
]

{ #category : #comparing }
MpName >> < rhs [
	self lastName < rhs lastName ifTrue: [ ^ true ].
	(self lastName = rhs lastName and: [ self firstName < rhs firstName ]) ifTrue: [ ^ true ].
	(self lastName = rhs lastName and: [ self firstName = rhs firstName ]) ifTrue: [ 
		(self middleName isNotNil and: [ rhs middleName isNotNil ]) ifTrue: [ self middleName < rhs middleName ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #comparing }
MpName >> <= rhs [
	self lastName <= rhs lastName ifTrue: [ ^ true ].
	(self lastName = rhs lastName and: [ self firstName <= rhs firstName ]) ifTrue: [ ^ true ].
	(self lastName = rhs lastName and: [ self firstName = rhs firstName ]) ifTrue: [ 
		(self middleName isNotNil and: [ rhs middleName isNotNil ]) ifTrue: [ self middleName <= rhs middleName ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #comparing }
MpName >> = rhs [
	^ self isSameAs: rhs
]

{ #category : #private }
MpName >> abbreviationsFor: givenNameString [
	| map result |
	result := OrderedCollection new.
	givenNameString ifNil: [ ^ result ].
	result add: givenNameString first asString.
	map := {
		('Robert' -> #('Rbt' 'Rob')).
		('Russell' -> #('Russ')).
		('Daniel' -> #('Dan' 'Danny')).
		('Christopher' -> #('Chris' 'Christophe' 'Christop')).	"NR-specific workaround, not an actual solution!!"
		('Peter' -> #('Ptr')).
		('Michael' -> #('Mike')).
		('Stephen' -> #('Steve')).
		('Steven' -> #('Steve')) } asDictionary.
	map at: givenNameString ifPresent: [ :c | result addAll: c ].
	^ result
]

{ #category : #comparing }
MpName >> detectMostSimilarIn: collection [
	| maxSimilarity candidates |
	maxSimilarity := collection max: [ :e | e name similarityTo: self ].
	candidates := collection select: [ :e | 
		| similarity |
		similarity := e name similarityTo: self.
		similarity = maxSimilarity ].
	self assert: candidates size = 1.
	^ candidates first
]

{ #category : #accessing }
MpName >> firstName [
	^ firstName
]

{ #category : #accessing }
MpName >> firstName: anObject [
	firstName := anObject
]

{ #category : #Magritte }
MpName >> firstNameDescription [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #firstName;
			priority: 100;
			propertyAt: #shouldAutoMergeBlock put: self shouldAutoMergeBlock;
			beRequired;
			yourself
]

{ #category : #accessing }
MpName >> fullName [
	^ String streamContents: [ :str | self printOn: str ]
]

{ #category : #accessing }
MpName >> generational [
	"https://en.wikipedia.org/wiki/Suffix_(name)"
	^ generational
]

{ #category : #accessing }
MpName >> generational: anObject [
	generational := anObject
]

{ #category : #Magritte }
MpName >> generationalDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
			accessor: #generational;
			priority: 400;
			options: MpGenerational all;
			undefinedValue: MpNoGenerational new;
			default: MpNoGenerational new;
			propertyAt: #shouldAutoMergeBlock put: self shouldAutoMergeBlock;
			yourself
]

{ #category : #comparing }
MpName >> hash [
	^ self maHash
]

{ #category : #testing }
MpName >> is: newValue anInterestingReplacementFor: oldValue [
	newValue isEmptyOrNil ifTrue: [ ^ false ].
	(newValue isKindOf: MpGenerational) ifTrue: [ 
		oldValue isEmptyOrNil ifTrue: [ ^ true ].
		^ (newValue matches: oldValue) not ].
	((self abbreviationsFor: oldValue) includes: newValue mpAsCanonicalName) ifTrue: [ ^ false ].
	^ super is: newValue mpAsCanonicalName anInterestingReplacementFor: (oldValue ifNotNil: [ oldValue mpAsCanonicalName ])
]

{ #category : #accessing }
MpName >> lastName [
	^ lastName
]

{ #category : #accessing }
MpName >> lastName: anObject [
	lastName := anObject
]

{ #category : #Magritte }
MpName >> lastNameDescription [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #lastName;
			priority: 300;
			propertyAt: #shouldAutoMergeBlock put: self shouldAutoMergeBlock;
			beRequired;
			yourself
]

{ #category : #merging }
MpName >> merge: rhs [

	self magritteDescription do: [ :desc | desc mergeFrom: rhs to: self ]
]

{ #category : #private }
MpName >> merge: rhs into: aSelector [

	| current input isInputBetter |
	current := self perform: aSelector.
	input := rhs perform: aSelector.
	current = input ifTrue: [ ^ self ].
	"current last = $. ifTrue: [ current := current allButLast ]."
	isInputBetter := input beginsWith: current.
	isInputBetter
		ifTrue: [ | setter |
			setter := (aSelector, ':') asSymbol.
			self perform: setter with: input ]
		ifFalse: [ self error: 'Conflict: ', (current -> input) asString ]
	
]

{ #category : #accessing }
MpName >> middleName [
	^ middleName
]

{ #category : #accessing }
MpName >> middleName: aString [
	middleName := aString
]

{ #category : #Magritte }
MpName >> middleNameDescription [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #middleName;
			priority: 200;
			propertyAt: #shouldAutoMergeBlock put: self shouldAutoMergeBlock;
			yourself
]

{ #category : #converting }
MpName >> mpAsName [
	^ self
]

{ #category : #merging }
MpName >> patchRelativeToBase: oldValue as: description of: receiver [
	"Edit me in place instead of full replacement like a value object"
	^ self patchRelativeToBase: oldValue
]

{ #category : #printing }
MpName >> printOn: aStream [
	firstName ifNotNil: [ :fn | aStream nextPutAll: fn ].
	middleName ifNotNil: [ :mn | 
		aStream
			space;
			nextPutAll: mn.
		mn size = 1 ifTrue: [ aStream nextPut: $. ] ].
	lastName ifNotNil: [ :ln | 
		aStream
			space;
			nextPutAll: ln ].
	generational ifNotNil: [ :gen | 
		gen displayString ifNotEmpty: [ :str |
			aStream
				space;
				nextPutAll: str ] ]
]

{ #category : #Magritte }
MpName >> shouldAutoMergeBlock [

	^ [ :old :new |
			| oldNoPeriod |
			oldNoPeriod := old trimRight: [ :e | e = $. ].
			new beginsWith: oldNoPeriod ]
]

{ #category : #comparing }
MpName >> similarityBetweenGenerationals: lhs and: rhs ifConflicting: aBlock [

	(lhs isEmptyOrNil or: [ rhs isEmptyOrNil ]) ifTrue: [ ^ 0 percent ].
	"Since they are a fixed set of domain objects, the comparison is straightforward"
	lhs = rhs ifTrue: [ ^ 100 percent ].
	^ aBlock value
]

{ #category : #comparing }
MpName >> similarityBetweenGivenNames: aName and: anotherName ifConflicting: aBlock [

	(aName isNil or: [ anotherName isNil ]) ifTrue: [ ^ 0 percent ].
	
	((self abbreviationsFor: aName) includes: anotherName mpAsCanonicalName) ifTrue: [ ^ 50 percent ].
	((self abbreviationsFor: anotherName) includes: aName mpAsCanonicalName) ifTrue: [ ^ 50 percent ].
	aName mpAsCanonicalName = anotherName mpAsCanonicalName ifTrue: [ ^ 100 percent ].
	^ aBlock value
]

{ #category : #comparing }
MpName >> similarityTo: rhs [

	| score lastNameWeight firstNameWeight middleNameWeight generationalWeight |
	score := 0.0.
	lastNameWeight := 50.0 percent.
	firstNameWeight := 25.0 percent.
	middleNameWeight := 15.0 percent.
	generationalWeight := 10.0 percent.
	
	self lastName mpAsCanonicalName = rhs lastName mpAsCanonicalName
		ifFalse: [ ^ 0.0 ]
		ifTrue: [ score := score + lastNameWeight ].
	score := score + ((self similarityBetweenGenerationals: self generational and: rhs generational ifConflicting: [ ^ 0.0 ]) * generationalWeight).
	score := score + ((self similarityBetweenGivenNames: self firstName and: rhs firstName ifConflicting: [ ^ 0.0 ]) * firstNameWeight).
	score := score + ((self similarityBetweenGivenNames: self middleName and: rhs middleName ifConflicting: [ ^ 0.0 ]) * middleNameWeight).
	^ score
]
