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
MpAddressBook class >> exampleHarryPotter [
	<gtExample>
	
	^ self
		given: [ self new ]
		when: [ :ab |
			ab contacts
				add: MpPerson exampleDumbledore;
				add: MpOrganization exampleLeakyCauldron;
				add: MpOrganization exampleOllivanders;
				yourself.
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
MpAddressBook >> contacts [
	^ contacts ifNil: [ contacts := SortedCollection sortUsing: #nameForAlphabetization ascending ]
]

{ #category : #convenience }
MpAddressBook >> ensureOrganizationNamed: aString [
	^ MpOrganization ensureNamed: aString.
	"For the moment, there are person and organization, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #convenience }
MpAddressBook >> ensurePersonNamed: aString [
	^ MpPerson ensureNamed: aString.
	"For the moment, there are person and organization, which seems like a closed set, leaving us with a fixed tolerable number of convenience messages. We'll see..."
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNewOrgFor: aStep [
	<gtSearch>
	aStep listProcessor
		title: 'New Organization';
		priority: 50;
		itemName: [ :input | 'Create new organization: ', input ];
		previewObject: [ :input | MpOrganization named: input ];
		wantsToDisplayOnEmptyQuery: false;
		filter: GtNullFilter
			item: [ :filter :context | 
				| isExisting |
				isExisting := self organizations anySatisfy: [ :e | 
					e fullName = context textTrimmed ].
				isExisting ifFalse: [ 
					filter value: context textTrimmed ] ];
		send: [ :newName :spotterStep | self ensureOrganizationNamed: newName ]
]

{ #category : #spotter }
MpAddressBook >> gtSpotterNewPersonFor: aStep [
	<gtSearch>
	self flag: 'copy pasted from new org spotter'.
	aStep listProcessor
		title: 'New person';
		priority: 60;
		itemName: [ :input | 'Add person: ', input ];
		previewObject: [ :input | MpPerson named: input trimBoth ];
		wantsToDisplayOnEmptyQuery: false;
		filter: GtNullFilter
			item: [ :filter :context | 
				| isExisting |
				isExisting := self people anySatisfy: [ :e | 
					e fullName = context textTrimmed ].
				(isExisting not and: [ MpPerson isValidName: context textTrimmed ]) ifTrue: [ 
					filter value: context textTrimmed ] ];
		send: [ :newName :spotterStep | self ensurePersonNamed: newName ]
]
