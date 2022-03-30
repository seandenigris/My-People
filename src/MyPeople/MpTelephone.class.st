Class {
	#name : #MpTelephone,
	#superclass : #Object,
	#instVars : [
		'areaCode',
		'prefix',
		'lineNumber'
	],
	#category : #'MyPeople-Core'
}

{ #category : #examples }
MpTelephone class >> example [
	<gtExample>
	^ self 
		given: []
		when: [ self fromString: '(212) 555-0100' ]
		then: [ :r |
			r countryCode should equal: 1.
			r areaCode should equal: 212.
			r exchange should equal: 555.
			r lineNumber should equal: 0100 ].
]

{ #category : #examples }
MpTelephone class >> fromString: aString [ 
]
