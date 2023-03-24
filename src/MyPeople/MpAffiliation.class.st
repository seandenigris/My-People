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
MpAffiliation >> addressBook [
	
	^ MpAddressBook uniqueInstance
]

{ #category : #accessing }
MpAffiliation >> hash [
	^ self organization ensureUUID hash bitXor: (self person ensureUUID hash bitXor: self role hash)
]

{ #category : #accessing }
MpAffiliation >> link [
	self person affiliations 
		detect: [ :aff |
			aff person == self person 
				and: [ aff organization == self organization 
					and: [ self role = aff role ] ] ]
		ifNone: [ self person affiliations add: self ].
	
	self organization affiliations 
		detect: [ :aff |
			aff person == self person 
				and: [ aff organization == self organization 
					and: [ self role = aff role ] ] ]
		ifNone: [ self organization affiliations add: self ].
]

{ #category : #accessing }
MpAffiliation >> linkDescription [
	<magritteActionDescription>
	
	^ MAActionDescription new
		  action: #link;
		  gtIcon: BrGlamorousVectorIcons link;
		  yourself
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
MpAffiliation >> organizationDescription [
	<magritteDescription>
	
	| searchSource |
	searchSource := PeGtDelegatedSearch
		to: self addressBook
		message: #organizationsSearchFor:.
	
	^ MAToOneRelationDescription new
		accessor: #organization;
		priority: 100;
		classes: MpOrganization withAllSubclasses;
		gtSearchSource: searchSource; 
		yourself
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
MpAffiliation >> personDescription [
	<magritteDescription>
	
	| searchSource |
	searchSource := PeGtDelegatedSearch
		to: self addressBook
		message: #peopleSearchFor:.
	
	^ MAToOneRelationDescription new
		accessor: #person;
		priority: 200;
		classes: MpPerson withAllSubclasses;
		gtSearchSource: searchSource; 
		yourself
]

{ #category : #accessing }
MpAffiliation >> printOn: aStream [

	aStream print: self organization.
		
	self role ifNotNil: [ :r |
		aStream
			space;
			nextPutAll: r ].
			
	aStream
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
MpAffiliation >> roleDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		accessor: #role;
		priority: 300;
		yourself
]

{ #category : #accessing }
MpAffiliation >> unlink [
	self person affiliations remove: self.
	self organization affiliations remove: self.
]
