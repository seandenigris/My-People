Class {
	#name : #MpAffiliation,
	#superclass : #Object,
	#traits : 'MATPropertyOwner',
	#classTraits : 'MATPropertyOwner classTrait',
	#instVars : [
		'organization',
		'person',
		'role'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpAffiliation class >> organization: anOrganization person: aPerson role: titleString [

	^ self new
		organization: anOrganization;
		person: aPerson;
		role: titleString;
		yourself
]

{ #category : #accessing }
MpAffiliation >> = rhs [
	
	^ [ 
		self organization = rhs organization and: [ self person = rhs person and: [ self role = rhs role ] ] 
	]
		on: Error do: [ false ]
]

{ #category : #accessing }
MpAffiliation >> hash [
	^ self organization hash bitXor: (self person hash bitXor: self role hash)
]

{ #category : #accessing }
MpAffiliation >> link [
	self person affiliations add: self.
	self organization affiliations add: self.
]

{ #category : #accessing }
MpAffiliation >> organization [

	^ organization
]

{ #category : #accessing }
MpAffiliation >> organization: anObject [

	organization := anObject
]

{ #category : #accessing }
MpAffiliation >> person [

	^ person
]

{ #category : #accessing }
MpAffiliation >> person: anObject [

	person := anObject
]

{ #category : #accessing }
MpAffiliation >> printOn: aStream [

	aStream
		print: self organization;
		space;
		nextPutAll: self role;
		space;
		print: self person
]

{ #category : #accessing }
MpAffiliation >> role [

	^ role
]

{ #category : #accessing }
MpAffiliation >> role: anObject [

	role := anObject
]

{ #category : #accessing }
MpAffiliation >> unlink [
	self person affiliations remove: self.
	self organization affiliations remove: self.
]
