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

	| fieldName address parser addressToken |
	fieldName := ($# asPParser, #space asPParser negate plus flatten) ==> #second.
	addressToken := (#space asPParser / $@ asPParser) negate plus.
	address := (addressToken, $@ asPParser, addressToken) flatten.
	parser := address, (#space asPParser plus, fieldName) optional ==> [ :n |
		self new
			address: n first;
			typeName: (n second ifNil: [ 'main' ] ifNotNil: [ n second second ]);
			yourself ].
	^ parser parse: aString.
]

{ #category : #accessing }
MpEmailField class >> fromStringNoLabelExample [
	<gtExample>
	
	^ self
		given: [ 'sean@clipperadams.com' ]
		when: [ :input | self fromString: input ]
		then: [ :result |
			result typeName should equal: #main.
			result address should equal: 'sean@clipperadams.com' ]
]

{ #category : #accessing }
MpEmailField class >> fromStringWithLabelExample [
	<gtExample>
	
	^ self
		given: [ 'sean@clipperadams.com #work' ]
		when: [ :input | self fromString: input ]
		then: [ :result |
			result typeName should equal: #work.
			result address should equal: 'sean@clipperadams.com' ]
]

{ #category : #accessing }
MpEmailField >> = rhs [

	^ super = rhs and: [ self address = rhs address ]
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
MpEmailField >> addressDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		accessor: #address;
		priority: 200;
		yourself
]

{ #category : #accessing }
MpEmailField >> displayStringOn: aStream [

	self address ifNotNil: [ :add | aStream nextPutAll: add ].
	self typeName ifNotNil: [ :str | 
		aStream 
			space;
			nextPutAll: str ].
]

{ #category : #accessing }
MpEmailField >> hash [

	^ super hash bitXor: self address hash
]

{ #category : #accessing }
MpEmailField >> printOn: aStream [

	self displayStringOn: aStream.
	
	aStream
		nextPutAll: ' ('.
		
	super printOn: aStream.
	
	aStream nextPut: $)
]
