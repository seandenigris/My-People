Class {
	#name : #MpAffiliation,
	#superclass : #Object,
	#traits : 'MATPropertyOwner',
	#classTraits : 'MATPropertyOwner classTrait',
	#instVars : [
		'organization',
		'person',
		'role',
		'roles'
	],
	#category : #'MyPeople-Core'
}

{ #category : #migrating }
MpAffiliation class >> migrateInstancesToMultipleRoles [
	self allSubInstancesDo: [ :e | 
		(e instVarNamed: #role) ifNotNil: [ :role | e roles add: role ] ]
]

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

{ #category : #printing }
MpAffiliation >> doesNotUnderstand: aMessage [
	
	^ self person
		ifNotNil: [ :info | aMessage sendTo: info ]
		ifNil: [ super doesNotUnderstand: aMessage ].
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
			
	aStream
		space;
		print: self person.
		
	self roles do: [ :r |
		aStream
			space;
			nextPutAll: r ].
]

{ #category : #accessing }
MpAffiliation >> role [
	self deprecated: 'Affiliations can now have multiple roles. Use something like `aff roles first` instead.'.

	 role ifNotNil: [ self roles add: role ].

	^ role
]

{ #category : #accessing }
MpAffiliation >> role: anObject [
	self deprecated: 'Affiliations can now have multiple roles. Use something like `aff roles add: aString` instead.'.
	
	self roles add: anObject.
	
	role := anObject
]

{ #category : #accessing }
MpAffiliation >> roles [
	^ roles ifNil: [ roles := Set new ]
	
	"Implementation note: originally was a Bag, but that means the number of occurences is significant, which it shouldn't be. We want to avoid duplicates. Since roles are currently strings, a Set should be fine/safe. If more dynamic objects are used for roles later, this should be reassessed"
]

{ #category : #accessing }
MpAffiliation >> roles: anObject [
	roles := anObject
]

{ #category : #accessing }
MpAffiliation >> rolesDescription [
	<magritteDescription>
	
	^ MAToManyRelationDescription new
		accessor: #roles;
		priority: 300;
		gtSearchDelegateTo: self message: #rolesGtSearchFor:;
		classes: { ByteString };
		yourself
]

{ #category : #accessing }
MpAffiliation >> rolesGtSearchFor: aSearch [
	<gtSearch>
	
	^ aSearch explicit
		title: 'New Role';
		
		priority: 300;
		search: [ :aContext | 
			| input |
			input := aContext searchQuery trimBoth.
			{ input } asAsyncStream ];
		send: [ :result | self roles add: result ]
]

{ #category : #accessing }
MpAffiliation >> unlink [
	self person affiliations remove: self.
	self organization affiliations remove: self.
]
