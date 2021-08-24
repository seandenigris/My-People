Class {
	#name : 'PeMyPeopleWiki',
	#superclass : 'Object',
	#traits : 'TAPWiki',
	#classTraits : 'TAPWiki classTrait',
	#category : 'MyPeople-Documentation'
}

{ #category : 'wikiPages' }
PeMyPeopleWiki class >> wikiPagePersistence [
	"This method was automatically generated."
	<wikiPage: 'Persistence'>
	^APWikiPage
		wiki: self
		name: 'Persistence'
		text: 
'!Porting
People were formerly collected on the class-side of ${class:MpPerson}$, but are now held in ${class:MpAddressBook}$ instances. To load data relying on the old scheme, temporarily add the following to ${class:MpPerson}$''s class-side:
[[[
restoreFrom: aCollection
	MpAddressBook default contacts addAll: aCollection
]]]'
]
