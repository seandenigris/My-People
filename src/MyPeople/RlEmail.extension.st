Extension { #name : #RlEmail }

{ #category : #'*MyPeople' }
RlEmail >> addressBook [

	^ MpAddressBook uniqueInstance
]

{ #category : #'*MyPeople' }
RlEmail >> isSender: anMpRelatableEntity [

	anMpRelatableEntity website ifNotNil: [ :web | 
		| websiteMatch |
		websiteMatch := web matchesDomain: self senderEmail domain.
		websiteMatch ifTrue: [ ^ true ] ].
		
	anMpRelatableEntity emailAddresses 
		detect: [ :contactEmail | contactEmail address = self senderEmail addressString ]
		ifFound: [ ^ true ].
		
	^ false
]

{ #category : #'*MyPeople' }
RlEmail >> sender [

	^ self addressBook contacts 
		detect: [ :c | self isSender: c ]
		ifNone: [ nil ]
]
