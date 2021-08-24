Class {
	#name : 'MpNoGenerational',
	#superclass : 'Object',
	#category : 'MyPeople-Core'
}

{ #category : 'comparing' }
MpNoGenerational >> = rhs [
	^ self class = rhs class
]

{ #category : 'displaying' }
MpNoGenerational >> displayStringOn: aStream [
]

{ #category : 'comparing' }
MpNoGenerational >> hash [
	^ self class hash
]

{ #category : 'accessing' }
MpNoGenerational >> token [
	^ nil
]
