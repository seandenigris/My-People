Trait {
	#name : #MpTEntityCollection,
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpTEntityCollection >> contacts [
	self subclassResponsibility
]

{ #category : #accessing }
MpTEntityCollection >> entryNamed: aString ifFound: foundBlock ifNone: noneBlock [
	^ self contacts detect: [ :e | e fullName = aString ] ifFound: foundBlock ifNone: noneBlock
]

{ #category : #spotter }
MpTEntityCollection >> gtGtSpotterForOrgsFor: aSearch [
	"Adapted from GT superclass"

	<gtSearch>
	^ aSearch list
		priority: 5;
		title: 'Organizations';
		items: [ self organizations ];
		matchSubstrings;
		itemName: [ :aContact | aContact fullName ]
]

{ #category : #spotter }
MpTEntityCollection >> gtGtSpotterForPeopleFor: aSearch [
	"Adapted from GT superclass"
	"<gtSearch> - don't include pragma when overriding to avoid duplicated processors, per Tudor via Discord 7/26/2021"
	
	^ aSearch list
		priority: 5;
		title: 'People';
		allCandidates: [ self people ];
		matchSubstrings;
		itemName:[ :aContact | 
			aContact name lastName , ', ' , aContact name firstName ].		
]

{ #category : #accessing }
MpTEntityCollection >> hasEntryNamed: aString [
	^ self contacts anySatisfy: [ :e | e fullName = aString ]
]

{ #category : #accessing }
MpTEntityCollection >> organizations [
	^ self contacts select: #isOrganization
]

{ #category : #accessing }
MpTEntityCollection >> people [
	^ self contacts select: #isPerson
]
