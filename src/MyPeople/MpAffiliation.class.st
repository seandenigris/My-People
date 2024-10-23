Class {
	#name : #MpAffiliation,
	#superclass : #Object,
	#traits : 'DbTDomainObject',
	#classTraits : 'DbTDomainObject classTrait',
	#instVars : [
		'organization',
		'person',
		'role',
		'roles'
	],
	#category : #'MyPeople-Core'
}

{ #category : #examples }
MpAffiliation class >> exampleDumbledore [
	<gtExample>

	^ MpAffiliation
		organization: MpOrganization exampleHogwarts
		member: MpPerson exampleDumbledore role: 'Headmaster'
]

{ #category : #migrating }
MpAffiliation class >> migrateInstancesToMultipleRoles [
	self allSubInstancesDo: [ :e | 
		(e instVarNamed: #role) ifNotNil: [ :role | e roles add: role ] ]
]

{ #category : #accessing }
MpAffiliation class >> organization: anOrganization member: aRelatableEntity role: titleString [

	| result |
	result := self new
		organization: anOrganization;
		member: aRelatableEntity;
		yourself.
		
	result roles add: titleString.
	
	^ result
]

{ #category : #accessing }
MpAffiliation >> = rhs [
	
	self species = rhs species ifFalse: [ ^ false ].
	
	^ self organization = rhs organization and: [ self member = rhs member and: [ self roles = rhs roles ] ].
]

{ #category : #accessing }
MpAffiliation >> addressBook [
	
	^ MpAddressBook uniqueInstance
]

{ #category : #printing }
MpAffiliation >> doesNotUnderstand: aMessage [
	
	^ self member
		ifNotNil: [ :info | aMessage sendTo: info ]
		ifNil: [ super doesNotUnderstand: aMessage ].
]

{ #category : #accessing }
MpAffiliation >> hash [
	^ self organization ensureUUID hash bitXor: (self member ensureUUID hash bitXor: self roles hash)
]

{ #category : #accessing }
MpAffiliation >> link [
	self memberLink.
	self organizationLink
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
MpAffiliation >> member [

	^ person
]

{ #category : #accessing }
MpAffiliation >> member: anObject [

	self memberUnlink.
	person := anObject.
	self memberLink.
]

{ #category : #accessing }
MpAffiliation >> memberDescription [
	<magritteDescription>
	
	| searchSource |
	searchSource := PeGtDelegatedSearch
		to: self addressBook
		message: #peopleSearchFor:.
	
	^ MAToOneRelationDescription new
		accessor: #member;
		priority: 200;
		classes: MpPerson withAllSubclasses;
		gtSearchSource: searchSource; 
		yourself
]

{ #category : #accessing }
MpAffiliation >> memberLink [
	self member affiliations
		detect: [ :aff | aff = self ]
		ifNone: [ self member affiliations add: self ]
]

{ #category : #accessing }
MpAffiliation >> memberUnlink [
	self member ifNotNil: [ :mbr | mbr affiliations remove: self ]
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
MpAffiliation >> organizationLink [
	self organization affiliations
		detect: [ :aff | aff = self ]
		ifNone: [ self organization affiliations add: self ]
]

{ #category : #accessing }
MpAffiliation >> organizationUnlink [
	self organization affiliations remove: self
]

{ #category : #accessing }
MpAffiliation >> person [
	self deprecated: 'Use #member instead'.

	^ self member
]

{ #category : #accessing }
MpAffiliation >> person: aRelatableEntity [
	self deprecated: 'Use #member: instead'.

	^ self member: aRelatableEntity
]

{ #category : #accessing }
MpAffiliation >> printOn: aStream [

	aStream print: self organization.
			
	aStream
		space;
		print: self member.
		
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
	self memberUnlink.
	self organizationUnlink
]
