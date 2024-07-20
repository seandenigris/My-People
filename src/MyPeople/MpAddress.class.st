Class {
	#name : #MpAddress,
	#superclass : #Object,
	#instVars : [
		'city',
		'country'
	],
	#category : #'MyPeople-Core'
}

{ #category : #comparing }
MpAddress >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ city = anObject city and: [ self country = anObject country ]
]

{ #category : #accessing }
MpAddress >> city [
	^ city
]

{ #category : #accessing }
MpAddress >> city: anObject [
	city := anObject
]

{ #category : #accessing }
MpAddress >> country [
	^ country
]

{ #category : #accessing }
MpAddress >> country: anObject [
	country := anObject
]

{ #category : #ui }
MpAddress >> gtSpotterForPeopleFor: aSearch [
	<gtSearch>
	(aSearch hasPreviousNavigationFromClass: GtABAddressBook)
		ifFalse: [ ^ aSearch empty ].
	^ aSearch list
		priority: 10;
		title: 'People';
		itemName: [ :contact | contact fullName ];
		items: [ aSearch previousStep origin contactsWithAddress: self ];
		itemsLimit: 10;
		matchSubstrings
]

{ #category : #comparing }
MpAddress >> hash [

	^ city hash bitXor: country hash
	
]

{ #category : #printing }
MpAddress >> printOn: aStream [

	aStream nextPutAll: self city.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self country
]
