Extension { #name : #MpRelatableEntity }

{ #category : #'*MyPeople' }
MpRelatableEntity >> uuidFromString36: aString [
	
	 ^ self propertyAt: #uuid put: (UUID fromString36: aString)
]
