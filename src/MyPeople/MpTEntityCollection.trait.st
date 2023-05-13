Trait {
	#name : #MpTEntityCollection,
	#category : #'MyPeople-Core'
}

{ #category : #searches }
MpTEntityCollection >> addressesSearchFor: aSearch [
	<gtSearch>
	
	^ aSearch list
		priority: 10;
		title: 'Addresses' translated;
		items: [ (self privateContacts flatCollect: #addresses as: Set) asOrderedCollection ];
		"itemName: [ :each | each city , ', ' , each country ];"
		matchSubstrings
]

{ #category : #accessing }
MpTEntityCollection >> contacts [
	^ self privateContacts
]

{ #category : #searches }
MpTEntityCollection >> contactsViewDetailedOn: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Contacts with details' translated;
		priority: 10;
		items: [ self privateContacts ];
		column: 'Avatar' 
			icon: [ :aContact | aContact avatar asElement asScalableElement size: 32 @ 32 ]
			width: 75;
		column: 'Name' text: [ :aContact | aContact fullName ];
		column: 'Phone' text: [ :aContact | aContact telephone ]
]

{ #category : #searches }
MpTEntityCollection >> contactsViewListOn: aView [
	<gtView>
	^ aView list
		title: 'Contacts List' translated;
		priority: 8;
		items: [ self privateContacts ];
		actionUpdateButton
]

{ #category : #searches }
MpTEntityCollection >> contactsWithAddress: anAddress [

	^ self snapshotFromContactsBlock: [ :aContact | 
		aContact address = anAddress ] 
]

{ #category : #searches }
MpTEntityCollection >> contactsWithTelephone: aNumber [

	^ self snapshotFromContactsBlock: [ :aContact | 
		aContact telephones anySatisfy: [ :aTelephone | 
			aTelephone number = aNumber ] ]
]

{ #category : #accessing }
MpTEntityCollection >> entryNamed: aString ifFound: foundBlock ifNone: noneBlock [
	^ self privateContacts detect: [ :e | e fullName = aString ] ifFound: foundBlock ifNone: noneBlock
]

{ #category : #accessing }
MpTEntityCollection >> googleCSVExport [

	| maxPhones |
	maxPhones := self privateContacts max: [ :e | e telephones size ].
	^ maxPhones
]

{ #category : #accessing }
MpTEntityCollection >> hasEntryNamed: aString [
	^ self privateContacts anySatisfy: [ :e | e fullName = aString ]
]

{ #category : #accessing }
MpTEntityCollection >> organizations [
	^ self snapshotFromContactsBlock: #isOrganization
]

{ #category : #accessing }
MpTEntityCollection >> organizationsSearchFor: aSearch [
	"Adapted from GT superclass"

	<gtSearch>
	^ aSearch list
		priority: 5;
		title: 'Organizations';
		items: [ self organizations asEntityCollection ];
		matchSubstrings;
		itemName: [ :aContact | aContact fullName ]
]

{ #category : #accessing }
MpTEntityCollection >> people [
	^ self snapshotFromContactsBlock: #isPerson
]

{ #category : #searches }
MpTEntityCollection >> peopleSearchFor: aSearch [
	<gtSearch>
	
	^ aSearch list
		priority: 5;
		title: 'People';
		items: [ self people asEntityCollection ];
		matchSubstrings;
		itemName:[ :aContact | 
			aContact name lastName , ', ' , aContact name firstName ].		
]

{ #category : #accessing }
MpTEntityCollection >> printOn: aStream [

	aStream 
		print: self privateContacts size;
		nextPutAll: ' contacts'
]

{ #category : #accessing }
MpTEntityCollection >> privateContacts [
	self explicitRequirement
]

{ #category : #accessing }
MpTEntityCollection >> removeDuplicateContactFields [

	self privateContacts do: [ :entity | 
		entity telephones: entity telephones asSet asOrderedCollection.
		entity emailAddresses: entity emailAddresses asSet asOrderedCollection ]
]

{ #category : #searches }
MpTEntityCollection >> snapshotFromContactsBlock: aBlock [

	| matches |
	matches := self privateContacts select: aBlock.
	^ MpContactsSnapshot new
		privateContacts: matches asArray;
		yourself
]

{ #category : #searches }
MpTEntityCollection >> telephonesSearchFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 15;
		title: 'Telephones' translated;
		items: [ self privateContacts flatCollect: [ :aContact | aContact telephones ] ];
		matchSubstrings
]

{ #category : #accessing }
MpTEntityCollection >> usStates [
	^ self privateContacts select: #isUSState
]
