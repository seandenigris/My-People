Extension { #name : #String }

{ #category : #'*MyPeople' }
String >> asMpName [
	^ MpName fromString: self
]

{ #category : #'*MyPeople' }
String >> mpAsNameCase [

	| isAllCaps shouldNormalize |
	isAllCaps := self allSatisfy: #isUppercase.
	
	shouldNormalize := isAllCaps or: [ self allSatisfy: #isLowercase ].

	^ shouldNormalize
		ifTrue: [ self asLowercase capitalized ]
		ifFalse: [ self ]
]
