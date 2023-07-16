"
I exist because sometimes, you just need a real collection, not a collection-y domain object. For example, the following expect a collection:
- Magritte options descriptions
- GT searches

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
MpEntityCollection >> asEntityCollection [
	^ self
]

{ #category : #copying }
MpEntityCollection >> copyAddingFilter: aBlock [

	^ self select: aBlock
]

{ #category : #accessing }
MpEntityCollection >> privateFilteredContacts [
	^ self
]
