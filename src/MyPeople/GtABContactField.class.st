"
I am the root of all domain objects for the address book application


"
Class {
	#name : #GtABContactField,
	#superclass : #Object,
	#instVars : [
		'typeName'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
GtABContactField >> = rhs [

	self species = rhs species ifFalse: [ ^ false ].
	
	^ self typeName = rhs typeName
]

{ #category : #accessing }
GtABContactField >> hash [

	^ self typeName hash
]

{ #category : #accessing }
GtABContactField >> typeName [
	^ typeName
]

{ #category : #accessing }
GtABContactField >> typeName: anObject [
	typeName := anObject
]

{ #category : #accessing }
GtABContactField >> typeNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Label';
		accessor: #typeName;
		priority: 100;
		yourself
]
