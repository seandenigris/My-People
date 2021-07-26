Class {
	#name : #MpGenerational,
	#superclass : #Object,
	#instVars : [
		'token',
		'abbreviations'
	],
	#category : 'MyPeople-Core'
}

{ #category : #accessing }
MpGenerational class >> all [
	<gtExample>
	
	| options |
	options := #(
		('Junior' ('Jr.'))
		('Senior' ('Sr.'))
		('II' ())
		('III' ())).
	^ options collect: [ :e |
		self new
			token: e first;
			abbreviations: e second;
			yourself ]
]

{ #category : #'instance creation' }
MpGenerational class >> fromString: aString [

	^ self all detect: [ :e | e matches: aString ]
]

{ #category : #comparing }
MpGenerational >> = rhs [
	^ self token = rhs token and: [ self abbreviations hasEqualElements: rhs abbreviations ]
]

{ #category : #accessing }
MpGenerational >> abbreviations [
	^ abbreviations
]

{ #category : #accessing }
MpGenerational >> abbreviations: anObject [
	abbreviations := anObject
]

{ #category : #comparing }
MpGenerational >> hash [
	^ self token hash
]

{ #category : #testing }
MpGenerational >> isEmptyOrNil [
	^ false
]

{ #category : #testing }
MpGenerational >> matches: aString [ 
	aString asUppercase = self token asUppercase ifTrue: [ ^ true ].
	self abbreviations 
		detect: [ :abbrev | (aString asUppercase trimRight: [ :c | c = $. ]) = (abbrev asUppercase trimRight: [ :c | c = $. ]) ]
		ifFound: [ ^ true ].
	^ false
]

{ #category : #printing }
MpGenerational >> printOn: aStream [

	abbreviations 
		ifNotEmpty: [ aStream nextPutAll: abbreviations first ]
		ifEmpty: [ aStream nextPutAll: token ]
]

{ #category : #accessing }
MpGenerational >> token [
	^ token
]

{ #category : #accessing }
MpGenerational >> token: anObject [
	token := anObject
]
