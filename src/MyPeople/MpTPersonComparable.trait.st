"
The main entry point I provide is ${method:MpTPersonComparable>>#chanceIsSameAs:}$, which compares by name. See its method comment (and those of its sent messages) for more info.
"
Trait {
	#name : #MpTPersonComparable,
	#category : 'MyPeople-Core'
}

{ #category : #comparing }
MpTPersonComparable >> < aComparable [

	^ self name < aComparable name
]

{ #category : #comparing }
MpTPersonComparable >> <= aComparable [

	^ self name <= aComparable name
]

{ #category : #comparing }
MpTPersonComparable >> chanceIsSameAs: rhs [

	"Subclasses may want to add something like:
	self is: #uniqueID sameAs: rhs ifTrue: [ ^ 100 percent ] ifConflicting: [ ^ 0 percent ]."
	^ self similarityByNameTo: rhs.
]

{ #category : #testing }
MpTPersonComparable >> is: fieldAccessor sameAs: rhs ifTrue: trueBlock ifConflicting: conflictBlock [
	"
	Possible Scenarios:
		- Same - non-nil and equal. Return trueBlock's value. NB. Although 'nil and equal' could be considered 'Same', it is not interesting because it represents two unset values.
		- Conflicting - non-nil and not equal. Return conflictBlock's value
		- Uninteresting - one or both are nil; return whether both are nil NB. It might be better to add an ifNil: block argument, but we'll hold off until the use case presents itself"

	| mine theirs |
	mine := self perform: fieldAccessor.
	theirs := rhs perform: fieldAccessor.
	
	(mine isNil or: [ theirs isNil ]) ifTrue: [ ^ mine = theirs ].
	mine = theirs ifTrue: [ ^ trueBlock value ].
	^ conflictBlock value
]

{ #category : #'helper-comparing' }
MpTPersonComparable >> similarityByNameTo: rhs [
	"The reason this odd-sounding method was extracted is so a user can customize `chanceIsSameAs:` and still resuse this behavior without aliasing (because there is no equivalent of `super` for traits)"	
	^ self name similarityTo: rhs name.
]
