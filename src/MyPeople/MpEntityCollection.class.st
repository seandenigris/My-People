"
I exist because sometimes, you just need a real collection, not a collection-y domain object. For example, I was created to integrate with Magritte ToMany relationships, which expect a collection.

Implementation note: I used to be a SortedCollection, but:
- since I am a general class, it doesn't seem universally valid
- it was slowing the whole system down to a crawl!!
"
Class {
	#name : #MpEntityCollection,
	#superclass : #OrderedCollection,
	#traits : 'MpTEntityCollection',
	#classTraits : 'MpTEntityCollection classTrait',
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpEntityCollection >> privateContacts [
	^ self
]
