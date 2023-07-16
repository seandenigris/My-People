Class {
	#name : #MpContactsSnapshot,
	#superclass : #Object,
	#traits : 'MpTEntityCollection + PeTEnumerable',
	#classTraits : 'MpTEntityCollection classTrait + PeTEnumerable classTrait',
	#instVars : [
		'filter',
		'privateContacts'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpContactsSnapshot >> asEntityCollection [

	^ MpEntityCollection withAll: self privateFilteredContacts
]

{ #category : #accessing }
MpContactsSnapshot >> copyAddingFilter: aBlock [

	| myFilter |
	
	"Cache the current filter. If we send this in the new filter block further below, it will return the filter sometime later"
	myFilter := self filter.

	^ MpContactsSnapshot new
		privateContacts: self privateContacts;
		filter: [ :aff | 
			(myFilter value: aff) and: [ aBlock value: aff ] ];
		yourself
]

{ #category : #accessing }
MpContactsSnapshot >> filter [
	^ filter ifNil: [ [ :aff | true ] ]
]

{ #category : #accessing }
MpContactsSnapshot >> filter: anObject [
	filter := anObject
]

{ #category : #accessing }
MpContactsSnapshot >> privateContacts [
	^ privateContacts ifNil: [ privateContacts := SortedCollection sortUsing: #nameForAlphabetization ascending ]
]

{ #category : #accessing }
MpContactsSnapshot >> privateContacts: anObject [
	privateContacts := anObject
]

{ #category : #accessing }
MpContactsSnapshot >> privateFilteredContacts [

	^ filter 
		ifNil: [ self privateContacts ]
		ifNotNil: [  self privateContacts select: self filter ]
]
