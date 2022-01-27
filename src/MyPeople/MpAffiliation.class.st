Class {
	#name : #MpAffiliation,
	#superclass : #Object,
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
MpAffiliation >> link [
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
