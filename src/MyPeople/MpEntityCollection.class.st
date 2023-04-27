"
I exist because sometimes, you just need a real collection, not a collection-y domain object. For example, I was created to integrate with Magritte ToMany relationships, which expect a collection.
"
Class {
	#name : #MpEntityCollection,
	#superclass : #SortedCollection,
	#traits : 'MpTEntityCollection',
	#classTraits : 'MpTEntityCollection classTrait',
	#category : #'MyPeople-Core'
}

{ #category : #initialization }
MpEntityCollection >> initialize [
	super initialize.
	self sortBlock: #nameForAlphabetization ascending
]

{ #category : #accessing }
MpEntityCollection >> privateContacts [
	^ self
]
