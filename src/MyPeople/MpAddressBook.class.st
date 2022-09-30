"
I serve the function of what people might call an ''address book'' or a ''contact list'', but I represent something more essential - a collection of entities to which one relates in some capacity.

Some of these entities might be people, some organizations.

Some might have addresses and other contact information, but some probably won't. For example, I may have a relationship with Walt Whitman through his works, and want to store information about him, but a phone number?!

I am called an ''address book'', but I'm in search of a better name.

My superclass is ${class:GtABAddressBook}$. It has an example filled with some contacts - see ${class:GtABCartoonAddressBookExample}$. There's a bit of a rift with my parent, however. While I take advantage of its views, I have my own highly-opinionated model for the objects I contain.
"
Class {
	#name : #MpAddressBook,
	#superclass : #MpGtABAddressBook,
	#traits : 'MpTEntityCollection',
	#classTraits : 'MpTEntityCollection classTrait',
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpAddressBook class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #examples }
MpAddressBook class >> example [

	| result |
	result := self exampleCelebrities.
	result contacts addAll: self exampleHarryPotter contacts.
	^ result
]

{ #category : #examples }
MpAddressBook class >> exampleCelebrities [
	<gtExample>
	
	^ self
		given: [ self new ]
		when: [ :ab |
			ab contacts
				add: MpPerson exampleNassimTaleb;
				add: MpPerson exampleBretVictor;
				yourself.
			ab ]
		then: [ :col :ab | ab where contacts should haveSize: 2 ]	
]

{ #category : #examples }
MpAddressBook class >> exampleHarryPotter [
	<gtExample>
	
	^ self
		given: [ self new ]
		when: [ :ab |
			ab contacts
				add: MpPerson exampleDumbledore;
				add: MpOrganization exampleLeakyCauldron;
				add: MpOrganization exampleOllivanders.
			ab ]
		then: [ :col :ab | ab where contacts should haveSize: 3 ]	
]

{ #category : #accessing }
MpAddressBook class >> gtDefaultFor: aView inContext: aContext [
	<gtView>
	<gtClassView>
	^ aView composite
		title: 'Default';
		priority: 100;
		views: (self default gtViewsInContext: aContext)
]

{ #category : #persistence }
MpAddressBook class >> restoreFrom: anObject [

	default := anObject.
]

{ #category : #persistence }
MpAddressBook class >> spData [

	^ default
]

{ #category : #accessing }
MpAddressBook class >> uniqueInstance [
	"For compatibility with other common singletons. Maybe should replace #default completely. What is the use case for multiple address books?"
	^ self default
]

{ #category : #accessing }
MpAddressBook >> contacts [
	^ contacts ifNil: [ contacts := SortedCollection sortUsing: #nameForAlphabetization ascending ]
]

{ #category : #convenience }
MpAddressBook >> ensureMunicipalityNamed: aString [
	^ MpMunicipality ensureNamed: aString.
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #convenience }
MpAddressBook >> ensureOrganizationNamed: aString [
	^ MpOrganization ensureNamed: aString.
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #convenience }
MpAddressBook >> ensurePersonNamed: aString [
	^ MpPerson ensureNamed: aString.
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNew: aClass for: aSearch priority: aNumber [
	
	^ aSearch explicit
		title: 'New ', (aClass name allButFirst: 'Mp' size);
		itemName: [ :result | '+ ', result fullName ];
		search: [ :aContext | 
			| input |
			input := aContext searchQuery trimBoth.
			(aClass isValidName: input)
				ifTrue: [ { aClass named: input } asAsyncStream ]
				ifFalse: [ {} asAsyncStream ] ];
		itemActLogic: [ :newName | Halt now ]
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNewMunicipalityFor: aSearch [
	<gtSearch>
	
	^ self 
		gtSpotterNew: MpMunicipality
		for: aSearch 
		priority: 100
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNewOrgFor: aSearch [
	<gtSearch>
	
	^ self 
		gtSpotterNew: MpOrganization
		for: aSearch 
		priority: 50
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNewPersonFor: aSearch [
	<gtSearch>
	
	^ self 
		gtSpotterNew: MpPerson
		for: aSearch 
		priority: 60
]

{ #category : #accessing }
MpAddressBook >> printOn: aStream [

	aStream 
		print: self contacts size;
		nextPutAll: ' contacts'
]

{ #category : #accessing }
MpAddressBook >> usStates [
	^ self contacts select: #isUSState
]
