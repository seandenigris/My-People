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

{ #category : #accessing }
MpEntityCollection >> contacts [
	^ self
]

{ #category : #ui }
MpEntityCollection >> gtViewContactsIconsCircularOn: aView [
	<gtView>
	self contacts size > 2 ifFalse: [ ^ aView empty].
	^ aView mondrian
		title: 'Circular' translated;
		priority: 50;
		painting: [ :view |
			view nodes
				stencil: [ :aContact | 
					(aContact avatar scaledToSize: 124@124) asElement ];
				with: self contacts.
			view layout circle
				radius: 200 ]
]

{ #category : #ui }
MpEntityCollection >> gtViewContactsListOn: aView [
	<gtView>
	^ aView list
		title: 'Contacts List' translated;
		priority: 8;
		items: [ self contacts ];
		itemText: [ :aContact | aContact fullName asRopedText ]
]

{ #category : #ui }
MpEntityCollection >> gtViewContactsOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Contacts with details' translated;
		priority: 5;
		items: [ self contacts ];
		column: 'Avatar' 
			icon: [ :aContact | aContact avatar asElement asScalableElement size: 32 @ 32 ]
			width: 75;
		column: 'Name' text: [ :aContact | aContact fullName ];
		column: 'Phone' text: [ :aContact | aContact telephone ]
]

{ #category : #initialization }
MpEntityCollection >> initialize [
	super initialize.
	self sortBlock: #nameForAlphabetization ascending
]

{ #category : #accessing }
MpEntityCollection >> privateContacts [
	^ self
]
