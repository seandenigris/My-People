Extension { #name : #RlEmail }

{ #category : #'*MyPeople' }
RlEmail >> addressBook [

	^ MpAddressBook uniqueInstance
]

{ #category : #'*MyPeople' }
RlEmail >> sender [

	^ self addressBook contacts detect: [ :c | c emailAddresses anySatisfy: [ :eml | eml address = self senderEmail addressString ] ]
]
