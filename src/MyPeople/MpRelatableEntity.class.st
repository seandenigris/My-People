Class {
	#name : #MpRelatableEntity,
	#superclass : #Object,
	#traits : 'MpTPersonComparable + MATPropertyOwner',
	#classTraits : 'MpTPersonComparable classTrait + MATPropertyOwner classTrait',
	#instVars : [
		'name',
		'aliases',
		'avatar',
		'roles',
		'website',
		'addresses'
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

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> addresses [
	^ self maLazyInstVarUsing: self addressesDescription
]

{ #category : #accessing }
MpRelatableEntity >> addresses: anObject [
	addresses := anObject
]

{ #category : #accessing }
MpRelatableEntity >> addressesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
			accessor: #addresses;
			priority: 400;
			default: OrderedCollection new;
			classes: { MpUSAddress };
			yourself
]

{ #category : #accessing }
MpRelatableEntity >> affiliations [
	^ self propertyAt: #affiliations ifAbsentPut: [ Set new ]
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

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> description [
	^ ''
]

{ #category : #accessing }
MpRelatableEntity >> doesNotUnderstand: aMessage [
	^ self roles
		detect: [ :r | r respondsTo: aMessage selector ]
		ifFound: [ :r | aMessage sendTo: r ]
		ifNone: [ super doesNotUnderstand: aMessage ]
]

{ #category : #accessing }
MpRelatableEntity >> fullName [

	^ name asString.
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

{ #category : #testing }
MpRelatableEntity >> isOrganization [
	^ false
]

{ #category : #testing }
MpRelatableEntity >> isPerson [
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

{ #category : #printing }
MpRelatableEntity >> printOn: aStream [

	name displayStringOn: aStream.
]

{ #category : #accessing }
MpRelatableEntity >> roles [
	^ roles ifNil: [ roles := OrderedCollection new ]
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> telephone [
	^ ''
]

{ #category : #'GtABContact compatibility' }
MpRelatableEntity >> telephones [
	^ #()
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
