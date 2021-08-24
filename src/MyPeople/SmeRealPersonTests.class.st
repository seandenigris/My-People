Class {
	#name : 'SmeRealPersonTests',
	#superclass : 'TestCase',
	#category : 'MyPeople-Specifications'
}

{ #category : 'tests' }
SmeRealPersonTests >> testComparing [

	| person name samePerson |
	name := 'Arthur Schopenhauer'.
	person := MpPerson named: name.
	samePerson := MpPerson named: name.

	(person chanceIsSameAs: samePerson) should equal: 85 percent.
]

{ #category : 'tests' }
SmeRealPersonTests >> testCreation [
	"Process the following into a person object:
	
		Arthur Schopenhauer, German philosopher (1788 - 1860)"

	| person |
"	person := (SmeRealPerson named: 'Arthur Schopenhauer')
		occupation: 'German philosopher';
		birthDate: (Year year: 1788);
		dateOfDeath: (Year year: 1860).
	person fullName should = 'Arthur Schopenhauer'.
	person birthDate should = (Year year: 1788).
	person dateOfDeath should = (Year year: 1860)."
]

{ #category : 'tests' }
SmeRealPersonTests >> testPrinting [

	| person |
	person := MpPerson named: 'Arthur Schopenhauer'.

	person printString should equal: 'Arthur Schopenhauer'.
]
