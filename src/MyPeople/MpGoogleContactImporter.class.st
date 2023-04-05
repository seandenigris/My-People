Class {
	#name : #MpGoogleContactImporter,
	#superclass : #MACSVTwoStageImporter,
	#category : #'MyPeople-Google'
}

{ #category : #accessing }
MpGoogleContactImporter >> convertToDomainObjects: aCollectionOfDictionaries [
	^ aCollectionOfDictionaries 
		collect: [ :rowDict | 
			| mpEntity |
			
			mpEntity := (rowDict at: 'Name')
				ifNotNil: [ self newPersonFromRecord: rowDict ]
				ifNil: [ self newOrganizationFromRecord: rowDict ].
				
			self 
				initializePhonesFor: mpEntity
				fromRecord: rowDict.
				
			"self 
				initializeBudgetLinesFor: mpEntity
				fromRecord: rowDict."
				
			mpEntity ]
]

{ #category : #accessing }
MpGoogleContactImporter >> fieldNamePropertyKey [

	^ #googleCsvFieldName
]

{ #category : #accessing }
MpGoogleContactImporter >> initializeBudgetLinesFor: anOgMunisAccount fromRecord: aDictionary [
	
	| years |
	years := aDictionary keys asSet
		select: [ :e | e first isDigit ]
		thenCollect: #squeezeOutNumber.
	
	years do: [ :year |
		| yearDict expectedDict line |
		yearDict := aDictionary associationsSelect: [ :assoc |
			assoc key beginsWith: year asString ].
		
		expectedDict := Dictionary new.
		yearDict keysAndValuesDo: [ :k :v |
			| expectedKey |
			expectedKey := k copyAfter: Character space.
			"Clean up inconsistency in field names - Encumbrances vs. Encumbrances/Requisitions"
			expectedKey := expectedKey copyUpTo: $/.
			expectedDict at: expectedKey put: v ].
			
		line := OgMunisBudgetLine new
			year: year;
			yourself.
		self 
				initializeDomainObject: line
				fromRecord: expectedDict.
				
		anOgMunisAccount addBudgetLine: line ]
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
		fromRecord: aDictionary.
		
	^ result
]

{ #category : #accessing }
MpGoogleContactImporter >> newPersonFromRecord: aDictionary [

	| name |
	name := MpName new.
	
	self 
		initializeDomainObject: name
		fromRecord: aDictionary.
		
	^ MpPerson named: name
]
