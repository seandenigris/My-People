"
I model an address book that can hold a list of contacts.

I am adapted from GToolkit's {{gtClass:GtABAddressBook}} (I started life as a copy of it). I exist primarily because GT's contribution situation at the time made it too difficult to get even minor needed changes made reliably.


"
Class {
	#name : #MpGtABAddressBook,
	#superclass : #Object,
	#instVars : [
		'label',
		'contacts',
		'categories'
	],
	#classInstVars : [
		'default'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpGtABAddressBook class >> default [
	^ default ifNil: [ 
		default := self new
			label: 'My contacts'.
		default ]
]

{ #category : #'class initialization' }
MpGtABAddressBook class >> initialize [

	"ABAddressBook default loadFromFile: 'data/cartoon.adr'."
	self reset
]

{ #category : #accessing }
MpGtABAddressBook class >> reset [
	default := nil
]

{ #category : #adding }
MpGtABAddressBook >> addCategories: aCollectionOfCategories [
	aCollectionOfCategories do: [ :aCategory |
		self addCategory: aCategory ]
]

{ #category : #adding }
MpGtABAddressBook >> addCategory: aCategory [
	self assert: [ aCategory notNil ].
	self assert: [ aCategory addressBook isNil ].
	
	self categories addLast: aCategory.
	aCategory addressBook: self.
]

{ #category : #adding }
MpGtABAddressBook >> addContact: aContact [
	self contacts addLast: aContact.
]

{ #category : #adding }
MpGtABAddressBook >> addContacts: aList [
	self contacts addAll: aList
]

{ #category : #adding }
MpGtABAddressBook >> addOrMergeContact: aContact [
	"Add the given contact or merge it into an existing contact if possible."
	self contacts do: [ :anotherContact |
		(anotherContact canMerge: aContact) ifTrue: [ 
			anotherContact merge: aContact.
			^ self ] ].
	
	"If there was no merge, add the new contact to the address book."
	self addContact: aContact
	
]

{ #category : #accessing }
MpGtABAddressBook >> allContacts [
	^ self contacts
]

{ #category : #accessing }
MpGtABAddressBook >> categories [
	^ categories.
]

{ #category : #accessing }
MpGtABAddressBook >> contacts [
	"Returns the contacts that are not in any category"
	^ contacts
]

{ #category : #accessing }
MpGtABAddressBook >> contacts: anObject [
	contacts := anObject
]

{ #category : #filtering }
MpGtABAddressBook >> contactsWithAddress: anAddress [
	^self contacts select: [ :aContact | 
		aContact address = anAddress ] 
]

{ #category : #filtering }
MpGtABAddressBook >> contactsWithTelephone: aNumber [
	^self contacts select: [ :aContact | 
		aContact telephones anySatisfy: [ :aTelephone | 
			aTelephone number = aNumber ] ]
]

{ #category : #ui }
MpGtABAddressBook >> gtGtSpotterForAddressesFor: aStep [
	<gtSearch>
	^ aStep listProcessor
		priority: 10;
		title: 'Addresses' translated;
		allCandidates: [ (self contacts collect: #address as: Set) asOrderedCollection ];
		candidatesLimit: 7;
		itemName: [ :each | each city , ', ' , each country ];
		matchSubstrings
]

{ #category : #ui }
MpGtABAddressBook >> gtGtSpotterForPeopleFor: aStep [
	<gtSearch>
	^ aStep listProcessor
		priority: 5;
		title: 'People';
		allCandidates: [ self contacts ];
		filter: GtFilterSubstrings;
		candidatesLimit: 7;
		itemName:[ :aContact | 
			aContact lastName asUppercase , ', ' , aContact firstName ] 
]

{ #category : #ui }
MpGtABAddressBook >> gtGtSpotterForTelephonesFor: aStep [
	<gtSearch>
	^ aStep listProcessor
		priority: 15;
		title: 'Telephones' translated;
		allCandidates: [ self contacts flatCollect: [ :aContact | aContact telephones ] ];
		matchSubstrings
]

{ #category : #ui }
MpGtABAddressBook >> gtSpotterPreviewIn: aComposite [
	<spotterPreview: 10>
	aComposite list
		title: 'People' translated;
		display: #yourself;
		format: [ :contact | GTSpotterItemBrick new text: contact fullName; disable ];
		entity: self contacts
]

{ #category : #accessing }
MpGtABAddressBook >> gtViewCategoriesTreeWithContactsOn: aView [
	<gtView>

	(self categories isEmpty) ifTrue: [^ aView empty].
	^ aView tree
		title: 'Contacts Tree' translated;
		items: [ self categories ];
		children: [ :each |
			(each isCategory)
				ifTrue: [ each subcategories, each contacts ]
				ifFalse: [ #() ] ].
]

{ #category : #accessing }
MpGtABAddressBook >> gtViewContactsAddressOn: aView [
	<gtView>
	
	(self categories isEmpty) ifTrue: [^ aView empty].
	^ aView columnedTree
		title: 'Contacts Address' translated;
		items: [self categories];
		column: 'Contact' text: [:each | each];
		column: 'City' text: [:each | 
			(each isCategory)
				ifTrue: ['' asRopedText]
				ifFalse: [each address city]];
		column: 'Country' text: [:each |
			(each isCategory)
				ifTrue: ['' asRopedText]
				ifFalse: [each address country]];
		children: [ :each |
			(each isCategory)
				ifTrue: [ each subcategories, each contacts ]
				ifFalse: [ #() ] ].
]

{ #category : #ui }
MpGtABAddressBook >> gtViewContactsIconsCircularOn: aView [
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
MpGtABAddressBook >> gtViewContactsListOn: aView [
	<gtView>
	^ aView list
		title: 'Contacts List' translated;
		priority: 8;
		items: [ self contacts ];
		itemText: [ :aContact | aContact fullName asRopedText ]
]

{ #category : #ui }
MpGtABAddressBook >> gtViewContactsOn: aView [
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

{ #category : #adding }
MpGtABAddressBook >> importCategories: aCollectionOfCategories [
	aCollectionOfCategories do: [ :aCategory |
		self importCategory: aCategory  ]
]

{ #category : #adding }
MpGtABAddressBook >> importCategory: aCategory [
	self addCategory: aCategory.
	aCategory allContactsDo: [ :aContact |
		self addContact: aContact ]
]

{ #category : #testing }
MpGtABAddressBook >> includesContactWithFirstName: aFirstName [
	^ self contacts anySatisfy: [ :aContact | 
		aFirstName = aContact firstName ]
]

{ #category : #initialization }
MpGtABAddressBook >> initialize [
	contacts := OrderedCollection new.
	categories := OrderedCollection new.
]

{ #category : #accessing }
MpGtABAddressBook >> label [
	^ label ifNil: [ '' ]
]

{ #category : #accessing }
MpGtABAddressBook >> label: anObject [
	label := anObject
]

{ #category : #printing }
MpGtABAddressBook >> printOn: aStream [

	aStream nextPutAll: self label
]
