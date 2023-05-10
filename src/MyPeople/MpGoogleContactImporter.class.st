Class {
	#name : #MpGoogleContactImporter,
	#superclass : #MACSVTwoStageImporter,
	#category : #'MyPeople-Google'
}

{ #category : #accessing }
MpGoogleContactImporter class >> writeContacts: aCollection toFile: aFileReference [

	| writer |
	aFileReference writeStreamDo: [ :str | 
		writer := NeoCSVWriter on: str.
		writer
			addField: [ :e | e name firstName ];
			addField: [ :e | e name middleName ];
			addField: [ :e | e name lastName ];
			addField: [ :e | e name generational ];
			addField: [ :e | '* myContacts' ];
			addField: [ :e | e telephones ifNotEmpty: [ :phones | phones first typeName ] ];
			addField: [ :e | e telephones ifNotEmpty: [ :phones | phones first fullNumber ] ];
			addField: [ :e | e telephones size > 1 ifTrue: [ e telephones second typeName ] ];
			addField: [ :e | e telephones size > 1 ifTrue: [ e telephones second fullNumber ] ];
			addField: [ :e | 'MyPeople ID36' ];
			addField: [ :e | e uuid asString36 ];
			nextPutAll: aCollection ]
]

{ #category : #accessing }
MpGoogleContactImporter >> domainObjectFromDictionary: aDictionary [

	| mpEntity |
	mpEntity := (aDictionary at: 'Name')
		ifNotNil: [ self newPersonFromRecord: aDictionary ]
		ifNil: [ self newOrganizationFromRecord: aDictionary ].

	self 
		initializeDomainObject: mpEntity
		fromRecord: aDictionary
		mapping: [ :builder |
			builder
				map: 'Given Name' fieldTo: #firstNameDescription;
				map: 'Additional Name' fieldTo: #middleNameDescription;
				map: 'Family Name' fieldTo: #lastNameDescription;
				map: 'Name Suffix' fieldTo: #generationalDescription ].
				
	self initializeCustomFieldsFor: mpEntity fromRecord: aDictionary.
	
	self initializePhonesFor: mpEntity fromRecord: aDictionary.

	^ mpEntity
]

{ #category : #accessing }
MpGoogleContactImporter >> fieldNamePropertyKey [

	^ #googleCsvFieldName
]

{ #category : #accessing }
MpGoogleContactImporter >> initialize: aString customFieldValue: anObject for: anMpEntity [

	aString = 'MyPeople ID36' ifTrue: [
		anMpEntity uuidFromString36: anObject.
		^ self ].
		
	self error: 'unknown custom field'
]

{ #category : #accessing }
MpGoogleContactImporter >> initializeCustomFieldsFor: anMpEntity fromRecord: aDictionary [

	| fieldValue keyPrefix maxOrgs currentIndex fieldName |
	maxOrgs := 100. "This is a made-up limit"
	currentIndex := 1.
	[ 
		keyPrefix := 'Custom Field ',  currentIndex asString.
		aDictionary 
			at: keyPrefix, ' - Type'
			ifPresent: [ :fName | 
				fieldName := fName.
				true ]
			ifAbsent: [ false ] 
	] 
		whileTrue: [
			fieldValue := aDictionary at: keyPrefix, ' - Value'.
			fieldValue ifNotNil: [ 
				self 
					initialize: fieldName
					customFieldValue: fieldValue
					for: anMpEntity ].
			currentIndex := currentIndex + 1 ]
	 
	
]

{ #category : #accessing }
MpGoogleContactImporter >> initializeOrganizationsFor: anMpEntity fromRecord: aDictionary [

	| title org name keyPrefix maxOrgs currentIndex |
	maxOrgs := 100. "This is a made-up limit"
	currentIndex := 1.
	[ 
		keyPrefix := 'Organization ',  currentIndex asString.
		aDictionary includesKey: keyPrefix, ' - Type' ] whileTrue: [
	
		title := aDictionary at: keyPrefix, ' - Title'.
		name := aDictionary at: keyPrefix, ' - Name'.
		name ifNotNil: [ 
			org := (MpOrganization named: name)
				"typeName: typeName;"
				yourself.
			self error: 'does this make any sense?'.
			anMpEntity telephones add: org ] ]
	 
	
]

{ #category : #accessing }
MpGoogleContactImporter >> initializePhonesFor: anMpEntity fromRecord: aDictionary [

	| typeName phone number keyPrefix maxPhones currentIndex |
	maxPhones := 100. "This is a made-up limit"
	currentIndex := 1.
	[ 
		keyPrefix := 'Phone ',  currentIndex asString.
		aDictionary includesKey: keyPrefix, ' - Type' ] whileTrue: [
	
		typeName := aDictionary at: keyPrefix, ' - Type'.
		number := aDictionary at: keyPrefix, ' - Value'.
		number ifNotNil: [ 
			phone := (MpTelephone fromString: number)
				typeName: typeName;
				yourself.
			anMpEntity telephones add: phone ].
		currentIndex := currentIndex + 1 ]
]

{ #category : #accessing }
MpGoogleContactImporter >> newOrganizationFromRecord: aDictionary [

	| result |
	result := MpOrganization new.
	
	self 
		initializeDomainObject: result
		fromRecord: aDictionary
		mapping: [ :builder |
			builder map: 'Organization 1 - Name' fieldTo: #nameDescription ].
		
	^ result
]

{ #category : #accessing }
MpGoogleContactImporter >> newPersonFromRecord: aDictionary [

	| name |
	name := self 
		initializeDomainObject: MpName new
		fromRecord: aDictionary
		mapping: [ :builder |
			builder
				map: 'Given Name' fieldTo: #firstNameDescription;
				map: 'Additional Name' fieldTo: #middleNameDescription;
				map: 'Family Name' fieldTo: #lastNameDescription;
				map: 'Name Suffix' fieldTo: #generationalDescription.
			].
		
	^ MpPerson named: name
]
