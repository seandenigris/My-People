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
		items: [ (self flatCollect: #addresses as: Set) asOrderedCollection ];
		matchSubstrings
]

{ #category : #accessing }
MpTEntityCollection >> asEntityCollection [
	self explicitRequirement
]

{ #category : #accessing }
MpTEntityCollection >> contacts [
	self flag: 'Do not use. This will go away as soon as we figure out a way to support Dynabook data migration for users'.
	^ self privateFilteredContacts
]

{ #category : #searches }
MpTEntityCollection >> contactsGtViewListOn: aView [
	<gtView>
	^ self
		contactsGtViewListOn: aView 
		sortedUsing: #nameForAlphabetization ascending
]

{ #category : #searches }
MpTEntityCollection >> contactsGtViewListOn: aView sortedUsing: aBlock [
	
	^ aView list
		title: 'Contacts List' translated;
		priority: 8;
		items: [ self asEntityCollection sorted: aBlock ];
		actionUpdateButton
]

{ #category : #searches }
MpTEntityCollection >> contactsViewDetailedOn: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Contacts with details' translated;
		priority: 10;
		items: [ self asEntityCollection ];
		column: 'Avatar' 
			icon: [ :aContact | aContact avatar asElement asScalableElement size: 32 @ 32 ]
			width: 75;
		column: 'Name' text: [ :aContact | aContact fullName ];
		column: 'Phone' text: [ :aContact | aContact telephone ]
]

{ #category : #searches }
MpTEntityCollection >> contactsWithAddress: anAddress [

	^ self copyAddingFilter: [ :aContact | 
		aContact address = anAddress ] 
]

{ #category : #searches }
MpTEntityCollection >> contactsWithTelephone: aNumber [

	^ self copyAddingFilter: [ :aContact | 
		aContact telephones anySatisfy: [ :aTelephone | 
			aTelephone number = aNumber ] ]
]

{ #category : #copying }
MpTEntityCollection >> copyAddingFilter: aBlock [

	self explicitRequirement
]

{ #category : #accessing }
MpTEntityCollection >> entryNamed: aString ifFound: foundBlock ifNone: noneBlock [
	^ self detect: [ :e | e fullName = aString ] ifFound: foundBlock ifNone: noneBlock
]

{ #category : #accessing }
MpTEntityCollection >> googleCSVExport [

	| maxPhones |
	maxPhones := self max: [ :e | e telephones size ].
	^ maxPhones
]

{ #category : #accessing }
MpTEntityCollection >> hasEntryNamed: aString [
	^ self anySatisfy: [ :e | e fullName = aString ]
]

{ #category : #accessing }
MpTEntityCollection >> municipalities [
	^ self copyAddingFilter: #isMunicipality
]

{ #category : #accessing }
MpTEntityCollection >> organizations [
	^ self copyAddingFilter: #isOrganization
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
	^ self copyAddingFilter: #isPerson
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
			String streamContents: [ :aStream |
				aStream
					nextPutAll: aContact name lastName;
					nextPutAll: ', ';
					nextPutAll: aContact name firstName.
				aContact aliases ifNotEmpty: [
					aStream nextPutAll: ' "'.
					aContact aliases
						do: [ :alias | aStream nextPutAll: alias ]
						separatedBy: [ aStream nextPut: $/ ].
					aStream nextPut: $" ] ] ].		
]

{ #category : #accessing }
MpTEntityCollection >> printOn: aStream [

	aStream 
		print: self size;
		nextPutAll: ' contacts'
]

{ #category : #accessing }
MpTEntityCollection >> privateFilteredContacts [
	self explicitRequirement
]

{ #category : #accessing }
MpTEntityCollection >> removeDuplicateContactFields [

	self do: [ :entity | 
		entity telephones: entity telephones asSet asOrderedCollection.
		entity emailAddresses: entity emailAddresses asSet asOrderedCollection ]
]

{ #category : #searches }
MpTEntityCollection >> telephonesSearchFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 15;
		title: 'Telephones' translated;
		items: [ self flatCollect: [ :aContact | aContact telephones ] ];
		matchSubstrings
]

{ #category : #accessing }
MpTEntityCollection >> usStates [
	^ self copyAddingFilter: #isUSState
]
