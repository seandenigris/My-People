Class {
	#name : #MpUSState,
	#superclass : #MpOrganization,
	#instVars : [
		'postalCode'
	],
	#category : #'MyPeople-Core'
}

{ #category : #setup }
MpUSState class >> addAllToAddressBookSingleton [
	MpAddressBook uniqueInstance contacts addAll: self all
]

{ #category : #accessing }
MpUSState class >> all [
	| data |
	data := 	#(
		('Alabama' 'AL' ('Ala.' ))
		('Alaska' 'AK' ('Alaska' ))
		('Arizona' 'AZ' ('Ariz.' ))
		('Arkansas' 'AR' ('Ark.' ))
		('California' 'CA' ('Calif.' ))
		('Colorado' 'CO' ('Colo.' ))
		('Connecticut' 'CT' ('Conn.' ))
		('Delaware' 'DE' ('Del.' ))
		('Florida' 'FL' ('Fla.' ))
		('Georgia' 'GA' ('Ga.' ))
		('Hawaii' 'HI' ('Hawaii' ))
		('Idaho' 'ID' ('Idaho' ))
		('Illinois' 'IL' ('Ill.' ))
		('Indiana' 'IN' ('Ind.' ))
		('Iowa' 'IA' ('Iowa' ))
		('Kansas' 'KS' ('Kans.' ))
		('Kentucky' 'KY' ('Ky.' ))
		('Louisiana' 'LA' ('La.' ))
		('Maine' 'ME' ('Maine' ))
		('Maryland' 'MD' ('Md.' ))
		('Massachusetts' 'MA' ('Mass.' ))
		('Michigan' 'MI' ('Mich.' ))
		('Minnesota' 'MN' ('Minn.' ))
		('Mississippi' 'MS' ('Miss.' ))
		('Missouri' 'MO' ('Mo.' ))
		('Montana' 'MT' ('Mont.' ))
		('Nebraska' 'NE' ('Neb.' 'Nebr.'))
		('Nevada' 'NV' ('Nev.' ))
		('New Hampshire' 'NH' ('N.H.' ))
		('New Jersey' 'NJ' ('N.J.' ))
		('New Mexico' 'NM' ('N.Mex.' ))
		('New York' 'NY' ('N.Y.' ))
		('North Carolina' 'NC' ('N.C.' ))
		('North Dakota' 'ND' ('N.Dak.' ))
		('Ohio' 'OH' ('Ohio' ))
		('Oklahoma' 'OK' ('Okla.' ))
		('Oregon' 'OR' ('Ore.' 'Oreg'))
		('Pennsylvania' 'PA' ('Pa.' ))
		('Rhode Island' 'RI' ('R.I.' ))
		('South Carolina' 'SC' ('S.C.' ))
		('South Dakota' 'SD' ('S.Dak.' ))
		('Tennessee' 'TN' ('Tenn.' ))
		('Texas' 'TX' ('Tex.' ))
		('Utah' 'UT' ('Utah' ))
		('Vermont' 'VT' ('Vt.' ))
		('Virginia' 'VA' ('Va.' ))
		('Washington' 'WA' ('Wash.' ))
		('West Virginia' 'WV' ('W.Va.' ))
		('Wisconsin' 'WI' ('Wis.' 'Wisc'))
		('Wyoming' 'WY' ('Wyo.' ))
	).
	^ data collect: [ :e |
		self new
			name: e first;
			postalCode: e second;
			aliases: e third asOrderedCollection ]
]

{ #category : #testing }
MpUSState >> isUSState [
	^ true
]

{ #category : #accessing }
MpUSState >> matches: aString [
	self name = aString ifTrue: [ ^ true ].
	self postalCode = aString ifTrue: [ ^ true ].
	(self aliases includes: aString) ifTrue: [ ^ true ].
	^ false
]

{ #category : #accessing }
MpUSState >> postalCode [
	^ postalCode
]

{ #category : #accessing }
MpUSState >> postalCode: aString [ 
	postalCode := aString
]
