"
I serve the function of what people might call an ''address book'' or a ''contact list'', but I represent something more essential - a collection of entities to which one relates in some capacity.

Some of these entities might be people, some organizations.

Some might have addresses and other contact information, but some probably won't. For example, I may have a relationship with Walt Whitman through his works, and want to store information about him, but a phone number?!

I am called an ''address book'', but I'm in search of a better name.
"
Class {
	#name : #MpAddressBook,
	#superclass : #MpContactsSnapshot,
	#classVars : [
		'UniqueInstance'
	],
	#category : #'MyPeople-Core'
}

{ #category : #examples }
MpAddressBook class >> example [

	| result |
	result := self exampleCelebrities.
	result addAll: self exampleHarryPotter asEntityCollection.
	^ result
]

{ #category : #examples }
MpAddressBook class >> exampleCelebrities [
	<gtExample>
	
	^ self
		given: [ self new ]
		when: [ :ab |
			ab
				ensureContact: MpPerson exampleNassimTaleb;
				ensureContact: MpPerson exampleBretVictor;
				yourself  ]
		then: [ :col :ab | ab should haveSize: 2 ]	
]

{ #category : #examples }
MpAddressBook class >> exampleHarryPotter [
	<gtExample>
	
	^ self
		given: [ self new ]
		when: [ :ab |
			ab
				ensureContact: MpPerson exampleDumbledore;
				ensureContact: MpOrganization exampleLeakyCauldron;
				ensureContact: MpOrganization exampleOllivanders.
			ab ]
		then: [ :col :ab | ab should haveSize: 3 ]	
]

{ #category : #accessing }
MpAddressBook class >> gtDefaultFor: aView inContext: aContext [
	<gtView>
	<gtClassView>
	^ aView composite
		title: 'Default';
		priority: 100;
		views: (self uniqueInstance gtViewsInContext: aContext)
]

{ #category : #persistence }
MpAddressBook class >> restoreFrom: anObject [

	UniqueInstance := anObject.
]

{ #category : #persistence }
MpAddressBook class >> spData [

	^ UniqueInstance
]

{ #category : #accessing }
MpAddressBook class >> uniqueInstance [
	
	^ UniqueInstance
]

{ #category : #accessing }
MpAddressBook >> add: aRelatableEntity [

	^ self ensureContact: aRelatableEntity
]

{ #category : #accessing }
MpAddressBook >> addAll: aCollection [

	^ aCollection do: [ :aRelatableEntity | self ensureContact: aRelatableEntity ]
]

{ #category : #accessing }
MpAddressBook >> ensureContact: aRelatableEntity [

	(self privateContacts identityIncludes: aRelatableEntity)
		ifFalse: [ 
			self privateContacts add: aRelatableEntity.
			aRelatableEntity addressBookBasic: self ].
		
	^ aRelatableEntity
]

{ #category : #convenience }
MpAddressBook >> ensureMunicipalityNamed: aString [

	^ self municipalities
		detect: [ :org | org name = aString ]
		ifNone: [ 
			| newOrg |
			newOrg := MpMunicipality named: aString.
			self ensureContact: newOrg ].
			
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #convenience }
MpAddressBook >> ensureOrganizationNamed: aString [

	^ self organizations
		detect: [ :org | org name = aString ]
		ifNone: [ 
			| newOrg |
			newOrg := MpOrganization named: aString.
			self ensureContact: newOrg ].
			
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #convenience }
MpAddressBook >> ensurePersonNamed: aStringOrMpName [
	
	^ self people
		detect: [ :org | org name = aStringOrMpName mpAsName ]
		ifNone: [ 
			| newOrg |
			newOrg := MpPerson named: aStringOrMpName.
			self ensureContact: newOrg ].
			
	"For the moment, there are person, organization and numicipality, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #spotter }
MpAddressBook >> municipalitiesSearchNewFor: aSearch [
	<gtSearch>
	
	^ self 
		searchNew: MpMunicipality
		for: aSearch 
		priority: 100
]

{ #category : #spotter }
MpAddressBook >> organizationsSearchNewFor: aSearch [
	<gtSearch>
	
	^ self 
		searchNew: MpOrganization
		for: aSearch 
		priority: 50
]

{ #category : #spotter }
MpAddressBook >> peopleSearchNewFor: aSearch [
	<gtSearch>
	
	^ self 
		searchNew: MpPerson
		for: aSearch 
		priority: 60
]

{ #category : #spotter }
MpAddressBook >> searchNew: aClass for: aSearch priority: aNumber [
	
	^ aSearch explicit
		title: 'New ', (aClass name allButFirst: 'Mp' size);
		itemName: [ :result | '+ ', result fullName ];
		priority: aNumber;
		search: [ :aContext | 
			| input |
			input := aContext searchQuery trimBoth.
			(aClass isValidName: input)
				ifTrue: [ { aClass named: input } asAsyncStream ]
				ifFalse: [ {} asAsyncStream ] ];
		send: [ :result | self privateContacts add: result ]
]
