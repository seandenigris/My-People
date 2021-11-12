Class {
	#name : #MpPerson,
	#superclass : #MpRelatableEntity,
	#instVars : [
		'occupation',
		'yearOfDeath',
		'dateOfBirth'
	],
	#classInstVars : [
		'contacts'
	],
	#category : #'MyPeople-Core'
}

{ #category : #examples }
MpPerson class >> exampleAffiliation [
	<gtExample>
	| org result |
	result := self exampleDumbledore.
	org := MpOrganization named: 'Hogwarts'.
	result addAffiliationWith: org as: 'Headmaster'.
	result should be isAffiliatedWith: org.
	^ result
		
]

{ #category : #examples }
MpPerson class >> exampleDumbledore [
	<gtExample>
	| result |
	result := MpPerson named: 'Albus Percival Dumbledore'.
	result where name lastName should equal: 'Dumbledore'.
	^ result
]

{ #category : #example }
MpPerson class >> exampleFlickrUser [
	^ MpPerson new
		propertyAt: #flickrUsername put: 'sixteenmilesofstring';
		yourself
]

{ #category : #utilities }
MpPerson class >> exampleMatch: masterList to: prospectList [

	^ masterList collect: [ :m | { m. prospectList select: [ :pm | (m chanceIsSameAs: pm) > 0 percent ] } ].
]

{ #category : #examples }
MpPerson class >> exampleNassimTaleb [
	^ MpPerson named: 'Nassim Taleb'
]

{ #category : #testing }
MpPerson class >> isValidName: aString [

	^ MpName isValidInput: aString
]

{ #category : #'instance creation' }
MpPerson class >> named: convertibleToName [

	^ self new
		name: convertibleToName mpAsName;
		yourself
]

{ #category : #accessing }
MpPerson >> addAffiliationWith: anOrganization as: titleString [
	^ self affiliations at: anOrganization put: titleString
]

{ #category : #accessing }
MpPerson >> affiliations [
	^ self propertyAt: #affiliations ifAbsentPut: [ Dictionary new ]
]

{ #category : #accessing }
MpPerson >> ageOn: aDate [

	^ aDate yearsSince: self dateOfBirth
]

{ #category : #accessing }
MpPerson >> birthdate [
	self 
		deprecated: 'Renamed to #dateOfBirth'
		transformWith: '`@receiver birthdate' -> '`@receiver dateOfBirth'.
	^ self dateOfBirth.
]

{ #category : #accessing }
MpPerson >> birthdate: aDate [
	self 
		deprecated: 'Renamed to #dateOfBirth:'
		transformWith: '`@receiver birthdate:' -> '`@receiver dateOfBirth:'.

	self dateOfBirth: aDate.
]

{ #category : #accessing }
MpPerson >> dateOfBirth [

	^ dateOfBirth.
]

{ #category : #accessing }
MpPerson >> dateOfBirth: aDate [

	dateOfBirth := aDate.
]

{ #category : #magritte }
MpPerson >> dateOfBirthDescription [
	
	<magritteDescription>

	^ MADateDescription new
			accessor: #dateOfBirth;
			label: 'Birthday';
			priority: 200;
			yourself
]

{ #category : #accessing }
MpPerson >> defaultAvatar [
	^ GtABContact unknowsJoeAvatar
]

{ #category : #accessing }
MpPerson >> flickrUsername [
	^ self propertyAt: #flickrUsername
]

{ #category : #accessing }
MpPerson >> flickrUsername: aString [
	self propertyAt: #flickrUsername put: aString
]

{ #category : #accessing }
MpPerson >> fullName: aString [

	name := MpNameParser parse: aString onError: [ self error: 'Failed parsing ', aString ]
]

{ #category : #magritte }
MpPerson >> fullNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		shouldMerge: false;
		accessor: #fullName;
		beReadOnly;
		comment: 'Convenience to show whole name at once as string. For editing, see #name';
		priority: 100;
		yourself
]

{ #category : #accessing }
MpPerson >> gtSpotterPreviewIn: aComposite [
	<spotterPreview: 10>
	| previewMorph |
	previewMorph := GtABPreviewMorph new
		hSpaceFill;
		vSpaceFill;
		contact: self.
	aComposite custom: previewMorph asBrick
		vSpaceFill;
		hSpaceFill
]

{ #category : #accessing }
MpPerson >> isAffiliatedWith: anOrganization [
	^ self affiliations includesKey: anOrganization
]

{ #category : #testing }
MpPerson >> isOrganization [
	^ false
]

{ #category : #testing }
MpPerson >> isPerson [
	^ true
]

{ #category : #magritte }
MpPerson >> nameDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
			mergeInPlace: true;
			accessor: #name;
			label: 'Name';
			classes: { MpName };
			priority: 100;
			yourself
]

{ #category : #accessing }
MpPerson >> nameForAlphabetization [
	^ self fullName
]

{ #category : #accessing }
MpPerson >> occupation: aString [ 

	occupation := aString.
]

{ #category : #accessing }
MpPerson >> yearOfDeath [

	^ yearOfDeath.
]

{ #category : #accessing }
MpPerson >> yearOfDeath: aNumber [

	yearOfDeath := aNumber.
]
