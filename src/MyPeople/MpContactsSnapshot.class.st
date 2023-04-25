Class {
	#name : #MpContactsSnapshot,
	#superclass : #Object,
	#traits : 'MpTEntityCollection',
	#classTraits : 'MpTEntityCollection classTrait',
	#instVars : [
		'privateContacts'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpContactsSnapshot >> asEntityCollection [

	^ MpEntityCollection withAll: self privateContacts
		
]

{ #category : #accessing }
MpContactsSnapshot >> privateContacts [
	^ privateContacts ifNil: [ privateContacts := SortedCollection sortUsing: #nameForAlphabetization ascending ]
]

{ #category : #accessing }
MpContactsSnapshot >> privateContacts: anObject [
	privateContacts := anObject
]
