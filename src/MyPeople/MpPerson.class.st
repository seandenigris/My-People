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
MpPerson class >> exampleBretVictor [
	<gtExample>
	| result |
	result := MpPerson named: 'Bret Victor'.
	result
		website: 'http://worrydream.com' asUrl;
		twitterUsername: 'worrydream'.
	result where name lastName should equal: 'Victor'.
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

{ #category : #examples }
MpPerson class >> exampleHarryPotter [
	<gtExample>
	| result |
	result := MpPerson named: 'Harry Potter'.
	result where name lastName should equal: 'Potter'.
	^ result
]

{ #category : #utilities }
MpPerson class >> exampleMatch: masterList to: prospectList [

	^ masterList collect: [ :m | { m. prospectList select: [ :pm | (m chanceIsSameAs: pm) > 0 percent ] } ].
]

{ #category : #examples }
MpPerson class >> exampleNassimTaleb [
	| result |
	result := MpPerson named: 'Nassim Taleb'.
	result
		website: 'https://www.fooledbyrandomness.com' asUrl;
		twitterUsername: 'nntaleb'.
	result where name lastName should equal: 'Taleb'.
	^ result
]

{ #category : #testing }
MpPerson class >> isValidName: aString [

	^ MpName isValidInput: aString
]

{ #category : #'instance creation' }
MpPerson class >> named: convertibleToName [

	^ self new
		name: convertibleToName asMpName;
		yourself
]

{ #category : #accessing }
MpPerson >> addAffiliationWith: anOrganization as: titleString [
	| aff |
	aff := MpAffiliation organization: anOrganization member: self role: titleString.
	aff link.
	^ aff
]

{ #category : #'as yet unclassified' }
MpPerson >> age [
	^ self ageOn: Date today translateToUTC
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

{ #category : #'magritte-descriptions' }
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
	^ self propertyAt: #flickrUsername ifAbsent: [ nil ]
]

{ #category : #accessing }
MpPerson >> flickrUsername: aString [
	self propertyAt: #flickrUsername put: aString
]

{ #category : #accessing }
MpPerson >> fullName: aString [

	name := MpNameParser parse: aString onError: [ self error: 'Failed parsing ', aString ]
]

{ #category : #'magritte-descriptions' }
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
MpPerson >> isPerson [
	^ true
]

{ #category : #accessing }
MpPerson >> linkedInProfile: aString [
	self propertyAt: #linkedInProfile put: aString
]

{ #category : #accessing }
MpPerson >> linkedInProfileUrl [
	^ self 
		propertyAt: #linkedInProfile 
		ifPresent: [ :str | 
			| baseUrl |
			baseUrl := 'https://www.linkedin.com/in/' asUrl.
			baseUrl / str ]
		ifAbsent: [ nil ]
]

{ #category : #'magritte-descriptions' }
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
	^ self name lastNameFirst asUppercase copyWithout: $.
]

{ #category : #accessing }
MpPerson >> occupation: aString [ 

	occupation := aString.
]

{ #category : #accessing }
MpPerson >> ssaFullRetirementAge [

	| birthYear |
	birthYear := self dateOfBirth
		ifNotNil: [ :dob | dob year ]
		ifNil: [ ^ nil ].
	
	birthYear <= 1937 ifTrue: [ ^ 65 ].
	birthYear = 1938 ifTrue: [ ^ 65.02 ].
	birthYear = 1939 ifTrue: [ ^ 65.04 ].
	birthYear = 1940 ifTrue: [ ^ 65.06 ].
	birthYear = 1941 ifTrue: [ ^ 65.08 ].
	birthYear = 1942 ifTrue: [ ^ 65.1 ].
	
	(birthYear between: 1943 and: 1954) ifTrue: [ ^ 66 ].
	birthYear = 1955 ifTrue: [ ^ 66.02 ].
	birthYear = 1956 ifTrue: [ ^ 66.04 ].
	birthYear = 1957 ifTrue: [ ^ 66.06 ].
	birthYear = 1958 ifTrue: [ ^ 66.08 ].
	birthYear = 1959 ifTrue: [ ^ 66.1 ].
	birthYear >= 1960 ifTrue: [ ^ 67 ].
	
	"Reference: https://www.ssa.gov/oact/progdata/nra.html"
]

{ #category : #accessing }
MpPerson >> twitterUsername [
	^ self propertyAt: #twitterUsername ifAbsent: [ nil ]
]

{ #category : #accessing }
MpPerson >> twitterUsername: aString [
	^ self propertyAt: #twitterUsername put: aString
]

{ #category : #accessing }
MpPerson >> yearOfDeath [

	^ yearOfDeath.
]

{ #category : #accessing }
MpPerson >> yearOfDeath: aNumber [

	yearOfDeath := aNumber.
]
