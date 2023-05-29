Class {
	#name : #MpNameSpecification,
	#superclass : #TestCase,
	#category : #'MyPeople-Specifications'
}

{ #category : #expectations }
MpNameSpecification >> generationalOf: aMpName shouldMatch: aString [ 
	aMpName generational ifNil: [ ^ aString isNil ].
	^ (aMpName generational matches: aString) should be: true
]

{ #category : #expectations }
MpNameSpecification >> name: firstPerson shouldBe: percentage similarTo: secondPerson [
	
	| aName anotherName |
	aName := self nameFromArray: firstPerson.
	anotherName := self nameFromArray: secondPerson.
	(aName similarityTo: anotherName) should equal: percentage asFloat percent
]

{ #category : #expectations }
MpNameSpecification >> nameFromArray: aCollection [ 

	| result |
	result := MpName new 
		lastName: aCollection last;
		yourself.
		
		aCollection size > 1 ifTrue: [ result firstName: aCollection first ].
		aCollection size > 2 ifTrue: [ result middleName: aCollection second ].
	^ result
]

{ #category : #tests }
MpNameSpecification >> testComparing [

	| cases |
	
	cases := {
		"Person 1 | Person 2 | First Name Score | Middle Name Score | Last Name Score"
		{ #('Paul' 'Anthony' 'Smith'). #('Paul' 'Anthony' 'Cordero'). 0. 0. 0 }. "Different last name -> 0%"
		{ #('Smith'). #('Smith'). 0. 0. 50 }. "Last name is worth 50%"
		{ #('Paul' 'Smith'). #('Paul' 'Smith'). 25. 0. 50 }. "First name worth 35%"
		{ #('P' 'Smith'). #('P' 'Smith'). 25/2. 0. 50 }. "An initial (here first name) is worth half-credit"
		{ #('P' 'A' 'Smith'). #('P' 'Smith'). 25/2. 0. 50 }. "Missing info (here middle name) does not affect score"
		{ #(nil 'Anthony' 'Smith'). #(nil 'Anthony' 'Smith'). 0. 15. 50 }. "Middle name worth 15%"
		{ #('P' 'A' 'Smith'). #('P' 'A' 'Smith'). 25/2. 15/2. 50 }. 
		{ #('Paul' 'Anthony' 'Smith'). #('Paul' 'Anthony' 'Smith'). 25. 15. 50 }.
	}.
	
	cases do: [ :c | 	
		| firstPerson secondPerson percentage |
		
		firstPerson := c first.
		secondPerson := c second.
		percentage := c third + c fourth + c fifth.
		self name: firstPerson shouldBe: percentage similarTo: secondPerson ]
]

{ #category : #tests }
MpNameSpecification >> testMerging [

	| cases |
	
	cases := {
		"Person 1 | Person 2 | Change Commands"
		{ #('Paul' 'Anthony' 'Smith'). #('Paul' 'John' 'Smith'). #(middleName) }.
		{ #('Paul' 'Anthony' 'Smith'). #('Paul' 'A' 'Smith'). #() }. "Abbreviations are not interesting changes"
		{ #('Paul' 'Anthony' 'Smith'). #('Paul' nil 'Smith'). #() }. "Removals are not interesting changes"
		{ #('P' 'Anthony' 'Smith'). #('Paul' 'Anthony' 'Smith'). #(#firstName) }. "An improvement on an initial"
		{ #('Paul' nil 'Smith'). #('Paul' 'Anthony' 'Smith'). #(#middleName) }. "An improvement on a missing value"
		{ #('P' 'A' 'Smith'). #('Paul' 'Anthony' 'Smith'). #(#firstName middleName) }. "Multiple changes"
	}.
	
	cases do: [ :case | 	
		| firstPerson secondPerson baseName proposedName commands expectedChangedFields |
		
		firstPerson := case first.
		secondPerson := case second.
		expectedChangedFields := case third.
		
		baseName := self nameFromArray: firstPerson.
		proposedName := self nameFromArray: secondPerson.
	
		commands := (proposedName patchRelativeToBase: baseName) operations.
	
		commands size should equal: expectedChangedFields size.
		commands doWithIndex: [ :cmd :i |
			| readSelector field |
			readSelector := expectedChangedFields at: i.
			field := MpName new magritteDescription children detect: [ :d | d accessor readSelector = readSelector ].
			cmd should equal: (MAPatchOperation new receiver: baseName; field: field; oldValue: (baseName perform: readSelector); newValue: (proposedName perform: readSelector); yourself) ] ]
]

{ #category : #tests }
MpNameSpecification >> testParsing [
	
	| cases |
	cases := #(
		('Smith, John Jr.' 'John' nil 'Smith' 'Jr.')
		('Smith, John Paul' 'John' 'Paul' 'Smith' nil)
		('Smith, John Paul Jr.' 'John' 'Paul' 'Smith' 'Jr.')
		('JOHNSON, JIM R JR' 'Jim' 'R' 'Johnson' 'Jr.')
		('Ivan Edward Sutherland' 'Ivan' 'Edward' 'Sutherland' nil)).
	cases do: [ :case |
		| input name |
		input := case first.
		
		name := MpNameParser parse: input.
		
		name isPetit2Failure should be: false.
		name firstName should equal: case second.
		name middleName should equal: case third.
		name lastName should equal: case fourth.
		self generationalOf: name shouldMatch: case fifth ]
]

{ #category : #tests }
MpNameSpecification >> testParsingGenerational [

	| options |
	options := #('Jr.' 'Jr' 'Sr' 'Sr.' 'II' 'III').
	options do: [ :input | 
		| output |
		output := MpNameParser new generational end parse: input.
		output should equal: input ]
]
