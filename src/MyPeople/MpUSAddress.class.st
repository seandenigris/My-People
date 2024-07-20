"
# Parsing
Rather than handroll, it seemed like there should be something great out there.

The following python libraries were investigated:
- [usaddress](https://github.com/datamade/usaddress) - doesn't seem to install on ARM Macs. Filed [this issue](https://github.com/scrapinghub/python-crfsuite/issues/149) with the offending dependency
- [address_parser](https://pypi.org/project/address-parser/) is listed as beta and the last commit was in 2019
"
Class {
	#name : #MpUSAddress,
	#superclass : #MpAddress,
	#instVars : [
		'state',
		'zipCode',
		'streetAddress',
		'streetAddress2'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpUSAddress class >> fromString: aString [
	| tokens stateAndZip state |
	tokens := aString splitOn: $,.
	stateAndZip := tokens last trimBoth splitOn: Character space.
	state := MpAddressBook uniqueInstance usStates detect: [ :e | e matches: stateAndZip first trimBoth ].
	^ self new
		streetAddress: tokens first trimBoth;
		city: tokens second trimBoth;
		state: state;
		zipCode: stateAndZip second trimBoth;
		yourself
]

{ #category : #accessing }
MpUSAddress class >> fromStringExample [
	<gtExample>
	^ self fromString: '428 S. Main Street, Somewhere, NY 12345'
]

{ #category : #accessing }
MpUSAddress class >> gtSpotterNewFor: aSearch [
	<gtSearch>
	^ aSearch explicit
		title: 'New Address';
		priority: 50;
		itemName: [ :result | '+ ' , result gtDisplayText ];
		search: [ :context | self fromString: context searchQuery trimmed ]
]

{ #category : #accessing }
MpUSAddress class >> states [
	^ MpAddressBook uniqueInstance usStates asEntityCollection
]

{ #category : #'magritte-accessing' }
MpUSAddress >> cityDescription [
	<magritteDescription>
	^ MAStringDescription new
		priority: 200;
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
		priority: 300;
		accessor: #state;
		options: self class states;
		yourself
]

{ #category : #accessing }
MpUSAddress >> streetAddress [
	^ self maLazyInstVarUsing: self streetAddressDescription
]

{ #category : #accessing }
MpUSAddress >> streetAddress2 [
	^ streetAddress2
]

{ #category : #accessing }
MpUSAddress >> streetAddress2: anObject [
	streetAddress2 := anObject
]

{ #category : #'magritte-accessing' }
MpUSAddress >> streetAddress2Description [
	<magritteDescription>
	^ MAStringDescription new
		priority: 150;
		accessor: #streetAddress2;
		yourself
]

{ #category : #accessing }
MpUSAddress >> streetAddress: aString [
	streetAddress := aString
]

{ #category : #'magritte-accessing' }
MpUSAddress >> streetAddressDescription [
	<magritteDescription>
	^ MAStringDescription new
		priority: 100;
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
		priority: 400;
		accessor: #zipCode;
		yourself
]
