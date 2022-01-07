Extension { #name : #SpInstanceDeDuplicator }

{ #category : #'*MyPeople-GToolkit' }
SpInstanceDeDuplicator class >> examplePeople [
	<gtExample>
	
	| canon objs |
	^ self
		given: [ 
			canon := MpAddressBook exampleHarryPotter contacts.
			objs := Bag new
				addAll: canon;
				add: canon atRandom copy;
				add: (MpPerson named: 'Katniss Everdeen');
				yourself ]
		when: [ 
			(SpInstanceDeDuplicator forObjects: objs)
				canonInclusionTest: [ :e | canon identityIncludes: e ];
				idBlock: [ :e | e fullName ];
				yourself ]
		then: [ :d |
			d selectMergable groups should haveSize: 1.
			d selectValid groups should haveSize: canon size - 1.
			d selectUnmergable groups should haveSize: 1 ]
]
