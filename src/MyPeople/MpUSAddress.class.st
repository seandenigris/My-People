Class {
	#name : #MpUSAddress,
	#superclass : #GtABAddress,
	#instVars : [
		'state',
		'zipCode',
		'streetAddress'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpUSAddress class >> states [
	^ #('Alabama' 'Alaska' 'Arizona' 'Arkansas' 'California' 'Colorado' 'Connecticut' 'Delaware' 'Florida' 'Georgia' 'Hawaii' 'Idaho' 'Illinois' 'Indiana' 'Iowa' 'Kansas' 'Kentucky' 'Louisiana' 'Maine' 'Maryland' 'Massachusetts' 'Michigan' 'Minnesota' 'Mississippi' 'Missouri' 'Montana' 'Nebraska' 'Nevada' 'New Hampshire' 'New Jersey' 'New Mexico' 'New York' 'North Carolina' 'North Dakota' 'Ohio' 'Oklahoma' 'Oregon' 'Pennsylvania' 'Rhode Island' 'South Carolina' 'South Dakota' 'Tennessee' 'Texas' 'Utah' 'Vermont' 'Virginia' 'Washington' 'West Virginia' 'Wisconsin' 'Wyoming')
]

{ #category : #'magritte-accessing' }
MpUSAddress >> cityDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #city;
		yourself
]

{ #category : #accessing }
MpUSAddress >> country [
	^ 'USA'
]

{ #category : #accessing }
MpUSAddress >> printOn: aStream [
	aStream 
		maPrint: self streetAddressDescription for: self;
		cr;
		maPrint: self cityDescription for: self;
		nextPutAll: ', ';
		maPrint: self stateDescription for: self;
		nextPutAll: ', ';
		maPrint: self zipCodeDescription for: self;
		nextPutAll: ', ';
		nextPutAll: self country
]

{ #category : #accessing }
MpUSAddress >> state [
	^ self maLazyInstVarUsing: self stateDescription
]

{ #category : #accessing }
MpUSAddress >> state: anObject [
	state := anObject
]

{ #category : #'magritte-accessing' }
MpUSAddress >> stateDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: #state;
		options: self class states;
		yourself
]

{ #category : #accessing }
MpUSAddress >> streetAddress [
	^ self maLazyInstVarUsing: self streetAddressDescription
]

{ #category : #accessing }
MpUSAddress >> streetAddress: aString [
	streetAddress := aString
]

{ #category : #'magritte-accessing' }
MpUSAddress >> streetAddressDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #streetAddress;
		yourself
]

{ #category : #accessing }
MpUSAddress >> zipCode [
	^ self maLazyInstVarUsing: self zipCodeDescription
]

{ #category : #accessing }
MpUSAddress >> zipCode: aString [
	zipCode := aString
]

{ #category : #'magritte-accessing' }
MpUSAddress >> zipCodeDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #zipCode;
		yourself
]
