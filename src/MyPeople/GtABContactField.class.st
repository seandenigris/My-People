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
GtABContactField >> typeName [
	^ typeName
]

{ #category : #accessing }
GtABContactField >> typeName: anObject [
	typeName := anObject
]
