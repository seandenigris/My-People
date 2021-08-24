Class {
	#name : 'MpContactRole',
	#superclass : 'Object',
	#instVars : [
		'emailAddresses'
	],
	#category : 'MyPeople-Core'
}

{ #category : 'magritte' }
MpContactRole >> descriptionEmailAddresses [
	<magritteDescription>
	^ MAToManyRelationDescription new
			accessor: #emailAddresses;
			classes: { String };
			priority: 1000;
			yourself
]

{ #category : 'accessing' }
MpContactRole >> emailAddresses [
	^ emailAddresses ifNil: [ emailAddresses := OrderedCollection new ]
]

{ #category : 'accessing' }
MpContactRole >> emailAddresses: anObject [
	emailAddresses := anObject
]
