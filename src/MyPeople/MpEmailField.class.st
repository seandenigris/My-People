Class {
	#name : #MpEmailField,
	#superclass : #GtABContactField,
	#instVars : [
		'address'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpEmailField class >> fromString: aString [

	| fieldName address parser |
	fieldName := ($# asPParser, #space asPParser negate plus flatten) ==> #second.
	address := ($# asPParser negate, #space asPParser negate plus) flatten.
	parser := address, (#space asPParser plus, fieldName ==> #second) optional ==> [ :n |
		self new
			address: n first;
			name: (n second ifNil: [ 'main' ]);
			yourself ].
	^ parser parse: aString.
]

{ #category : #accessing }
MpEmailField class >> fromStringExample [
	<gtExample>
	
	^ self
		given: [ 'sean@clipperadams.com #main' ]
		when: [ :input | self fromString: input ]
		then: [ :result |
			result name should equal: #main.
			result address should equal: 'sean@clipperadams.com' ]
]

{ #category : #accessing }
MpEmailField >> address [

	^ address
]

{ #category : #accessing }
MpEmailField >> address: anObject [

	address := anObject
]

{ #category : #accessing }
MpEmailField >> printOn: aStream [

	self address ifNotNil: [ :add | aStream nextPutAll: add ].
	self name ifNotNil: [ :str | 
		aStream 
			space;
			nextPutAll: str ].
]
