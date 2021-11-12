Trait {
	#name : #MpTAlphabetizable,
	#category : #'MyPeople-Support'
}

{ #category : #accessing }
MpTAlphabetizable >> fullName [
	self subclassResponsibility
]

{ #category : #accessing }
MpTAlphabetizable >> nameForAlphabetization [
	
	^ #('A ' 'An ' 'The ') 
		detect: [ :article | self fullName beginsWith: article ] 
		ifFound: [ :art | self fullName asUppercase allButFirst: art size ] 
		ifNone: [ self fullName asUppercase ]
]
