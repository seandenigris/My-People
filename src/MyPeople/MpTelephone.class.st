"
Part names from [Wikipedia](https://en.wikipedia.org/wiki/North_American_Numbering_Plan)
"
Class {
	#name : #MpTelephone,
	#superclass : #GtABContactField,
	#instVars : [
		'areaCode',
		'lineNumber',
		'exchange',
		'countryCode'
	],
	#classInstVars : [
		'countryCode'
	],
	#category : #'MyPeople-Core'
}

{ #category : #'as yet unclassified' }
MpTelephone class >> countryCode [
	^ countryCode
]

{ #category : #examples }
MpTelephone class >> example [
	<gtExample>
	^ self 
		given: []
		when: [ self fromString: '(212) 555-0100' ]
		then: [ :r |
			r countryCode should equal: 1.
			r areaCode should equal: 212.
			r exchange should equal: 555.
			r lineNumber should equal: 0100 ].
]

{ #category : #examples }
MpTelephone class >> fromString: aString [
	| pyNumber nationalNumberStream |
	pyNumber:= PBApplication uniqueInstance 
		sendSource: '# https://github.com/daviddrysdale/python-phonenumbers
import phonenumbers
phonenumbers.parse(str, "US")' 
		withBindings: { #str -> aString }.
	
	nationalNumberStream := (pyNumber getAttribute: #national_number) asString readStream.
		
	^ self new
		countryCode: (pyNumber getAttribute: #country_code);
		areaCode: (nationalNumberStream next: 3) asNumber;
		exchange: (nationalNumberStream next: 3) asNumber;
		lineNumber: (nationalNumberStream upToEnd) asNumber;
		yourself
		
]

{ #category : #accessing }
MpTelephone >> areaCode [

	^ areaCode
]

{ #category : #accessing }
MpTelephone >> areaCode: anObject [

	areaCode := anObject
]

{ #category : #accessing }
MpTelephone >> countryCode [
	^ countryCode
]

{ #category : #'as yet unclassified' }
MpTelephone >> countryCode: anInteger [ 
	countryCode := anInteger
]

{ #category : #accessing }
MpTelephone >> displayStringOn: aStream [

	self fullNumber ifNotNil: [ :num | aStream nextPutAll: num ].
	
	self typeName ifNotNil: [ :str | 
		aStream 
			space;
			nextPutAll: str ].
]

{ #category : #accessing }
MpTelephone >> exchange [

	^ exchange
]

{ #category : #accessing }
MpTelephone >> exchange: anObject [

	exchange := anObject
]

{ #category : #accessing }
MpTelephone >> fullNumber [

	^ String streamContents: [ :str | 
		str
		nextPutAll: self countryCode asString;
			nextPutAll: ' (';
			nextPutAll: self areaCode asString;
			nextPutAll: ') ';
			nextPutAll: self exchange asString;
			nextPut: $-;
			nextPutAll: (self lineNumber asString padLeftTo: 4 with: $0) ]
]

{ #category : #accessing }
MpTelephone >> lineNumber [

	^ lineNumber
]

{ #category : #accessing }
MpTelephone >> lineNumber: anObject [

	lineNumber := anObject
]

{ #category : #accessing }
MpTelephone >> printOn: aStream [

	self displayStringOn: aStream.
	
	aStream
		nextPutAll: ' ('.
		
	super printOn: aStream.
	
	aStream nextPut: $)
]
