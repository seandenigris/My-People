Class {
	#name : #MpRelatableEntity,
	#superclass : #Object,
	#traits : 'MpTPersonComparable + MATPropertyOwner',
	#classTraits : 'MpTPersonComparable classTrait + MATPropertyOwner classTrait',
	#instVars : [
		'name',
		'aliases',
		'avatar',
		'website',
		'addresses',
		'emailAddresses'
	],
	#category : #'MyPeople-Core'
}

{ #category : #convenience }
MpRelatableEntity class >> ensureNamed: aString [
	"Assumes default Address Book"
	| collection |
	collection := MpAddressBook default contacts.
	^ collection
		detect: [ :e | e fullName asUppercase = aString asUppercase ]
		ifNone: [ 
			| new |
			new := self named: aString.
			collection add: new ].
	"Implementation note: This method is a holdover from before address book, when MpPerson has its own DB on its class-side. The problem is that now there are two axes: 1) which AddressBook and 2) which entity (e.g. person or organization)."
]

{ #category : #accessing }
MpRelatableEntity class >> isAbstract [
	^ false
]

{ #category : #testing }
MpRelatableEntity class >> isValidName: aString [

	^ true
]

{ #category : #comparing }
MpRelatableEntity >> = rhs [

	self class = rhs class ifFalse: [ ^ false ].
	^ self uuid = rhs uuid
]

{ #category : #accessing }
MpRelatableEntity >> addressBook [
	^ self
		propertyAt: #addressBook
		ifAbsent: [ MpAddressBook uniqueInstance ]
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> addresses [
	^ self maLazyInstVarUsing: self addressesDescription
]

{ #category : #accessing }
MpRelatableEntity >> addresses: anObject [
	addresses := anObject
]

{ #category : #'magritte-descriptions' }
MpRelatableEntity >> addressesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
			accessor: #addresses;
			priority: 400;
			default: OrderedCollection new;
			gtSearchDelegateTo: MpUSAddress message: #peGtSpotterNewInstanceFor:;
			classes: { MpUSAddress };
			yourself
]

{ #category : #accessing }
MpRelatableEntity >> affiliations [
	^ self propertyAt: #affiliations ifAbsentPut: [ Set new ]
]

{ #category : #accessing }
MpRelatableEntity >> affiliationsGtSearchFor: aSearch [
	<gtSearch>
	
	^ aSearch list
		priority: 40;
		title: 'Affiliations';
		items: [ self affiliations ];
		"itemName: #gtDisplayString;"
		filterBySubstring
]

{ #category : #accessing }
MpRelatableEntity >> aliases [
	^ self maLazyInstVarUsing: self aliasesDescription
]

{ #category : #accessing }
MpRelatableEntity >> aliases: anObject [
	aliases := anObject
]

{ #category : #accessing }
MpRelatableEntity >> aliasesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
			accessor: #aliases;
			priority: 300;
			default: Set new;
			classes: { ByteString };
			yourself
]

{ #category : #accessing }
MpRelatableEntity >> avatar [
	avatar ifNotNil: [ ^ avatar ].
	self avatarSource ifNotNil: [ :as | ^ as asForm ].
	^ self defaultAvatar
]

{ #category : #accessing }
MpRelatableEntity >> avatarSource [
	^ self
		propertyAt: #avatarSource
		ifAbsent: [ nil ]
]

{ #category : #accessing }
MpRelatableEntity >> avatarSource: formable [
	self
		propertyAt: #avatarSource
		put: formable
]

{ #category : #'magritte-descriptions' }
MpRelatableEntity >> avatarSourceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
			accessor: #avatarSource;
			priority: 500;
			gtSearchSource: (MessageSend receiver: RlResourceLibrary selector: #uniqueInstance);
			yourself
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> description [
	^ ''
]

{ #category : #accessing }
MpRelatableEntity >> emailAddresses [

	^ self maLazyInstVarUsing: self emailAddressesDescription
]

{ #category : #accessing }
MpRelatableEntity >> emailAddresses: anObject [

	emailAddresses := anObject
]

{ #category : #'magritte-descriptions' }
MpRelatableEntity >> emailAddressesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
			accessor: #emailAddresses;
			priority: 500;
			default: OrderedCollection new;
			"gtSearchSource: #e;"
			gtSearchDelegateTo: self message: #gtSpotterNewEmailAddressFor:;
			classes: { MpEmailField };
			yourself
]

{ #category : #accessing }
MpRelatableEntity >> fullName [

	^ name asString.
]

{ #category : #accessing }
MpRelatableEntity >> gtPhonesOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Phones' translated;
		priority: 10;
		items: [ self telephones ];
		column: 'Type' text: [ :e | e typeName ];
		column: 'Number' text: [ :e | e fullNumber ]
]

{ #category : #accessing }
MpRelatableEntity >> gtSpotterNewEmailAddressFor: aSearch [
	
	^ aSearch explicit
		title: 'New email';
		priority: 50;
		itemName: [ :result | '+ ' , result gtDisplayText ];
		search: [ :context | 
			| isExisting input |
			input := context searchQuery trimmed.
			self flag: 'what should be in empty collection?'.
			isExisting := #() anySatisfy: [ :e | e title = input ].
			isExisting 
				ifFalse: [ { MpEmailField fromString: input } ]
				ifTrue: [ { } ] ];
		send: [ :result | self emailAddresses add: result ]
]

{ #category : #accessing }
MpRelatableEntity >> gtViewAffiliationsOn: aView [
	<gtView>
	
	self affiliations ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Affiliations' translated;
		priority: 60;
		items: [ self affiliations asOrderedCollection ];
		actionUpdateButton
]

{ #category : #accessing }
MpRelatableEntity >> gtViewContactDetailsOn: aView [
	<gtView>
	^ aView explicit
		title: 'Details' translated;
		priority: 5;
		stencil:
				[ | container verticalContainer detailsTextContainer avatarContainer nameTextContainer details |
			details := String
				streamContents: [ :aStream | 
					self telephones
						do: [ :aTelephone | aStream nextPutAll: aTelephone fullNumber ]
						separatedBy: [ aStream cr ].
					aStream cr.
					self addresses
						do: [ :aTelephone | aStream nextPutAll: aTelephone gtDisplayString ]
						separatedBy: [ aStream cr ] ].
			container := BlElement new
				layout: BlLinearLayout horizontal;
				background: Color white;
				aptitude: BrShadowAptitude;
				margin: (BlInsets all: 20);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ].
			avatarContainer := BlElement new
				size: 124 @ 124;
				background: (self avatar scaledToSize: 124 @ 124);
				margin: (BlInsets all: 10).
			nameTextContainer := BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				margin:
					(BlInsets
						top: 5
						right: 0
						bottom: 20
						left: 5);
				text:
					(self fullName asRopedText glamorousRegularFont
						fontSize: 30;
						foreground: Color black).
			detailsTextContainer := BrEditor new
				aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 16);
				text: details;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			verticalContainer := BlElement new
				layout: BlLinearLayout vertical;
				margin: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			verticalContainer addChild: nameTextContainer.
			verticalContainer addChild: detailsTextContainer.
			container addChild: avatarContainer.
			container addChild: verticalContainer.
			container ]
]

{ #category : #accessing }
MpRelatableEntity >> gtViewPreviewOn: aView [
	<gtView>
	^ aView explicit
		title: 'Preview' translated;
		priority: 6;
		stencil: [
			"Use the old morph for now"
			((GtABPreviewMorph new contact: self) extent: 500@300)
				imageForm asElement asPannableElement ]
]

{ #category : #comparing }
MpRelatableEntity >> hash [

	^ self uuid hash
]

{ #category : #accessing }
MpRelatableEntity >> initialize [
	super initialize.
	self ensureUUID
]

{ #category : #testing }
MpRelatableEntity >> isOrganization [
	^ false
]

{ #category : #testing }
MpRelatableEntity >> isPerson [
	^ false
]

{ #category : #testing }
MpRelatableEntity >> isUSState [
	^ false
]

{ #category : #accessing }
MpRelatableEntity >> name [
	^ self maLazyInstVarUsing: self nameDescription
]

{ #category : #accessing }
MpRelatableEntity >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MpRelatableEntity >> nameForAlphabetization [

	self subclassResponsibility
]

{ #category : #accessing }
MpRelatableEntity >> newEmail [
	CwMacMail new newMessageTo: self fullName at: self emailAddresses atRandom address re: '' asFollows: ''
]

{ #category : #printing }
MpRelatableEntity >> printOn: aStream [

	name displayStringOn: aStream.
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> telephone [
	^ ''
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> telephones [
	^ self propertyAt: #telephones ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> telephones: aCollection [
	^ self propertyAt: #telephones putRemovingNil: aCollection
]

{ #category : #accessing }
MpRelatableEntity >> website [
	^ self maLazyInstVarUsing: self websiteDescription
]

{ #category : #accessing }
MpRelatableEntity >> website: anObject [
	website := anObject
]

{ #category : #'magritte-accessing' }
MpRelatableEntity >> websiteDescription [
	<magritteDescription>
	^ MAUrlDescription new
		accessor: #website;
		priority: 200;
		yourself
]
