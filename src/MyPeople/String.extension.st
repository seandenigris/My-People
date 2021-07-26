Extension { #name : #String }

{ #category : #'*MyPeople' }
String >> mpAsName [
	^ MpName fromString: self
]
