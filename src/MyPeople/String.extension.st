Extension { #name : #String }

{ #category : #'*MyPeople' }
String >> asMpName [
	^ MpName fromString: self
]
