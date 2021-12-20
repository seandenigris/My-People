Class {
	#name : #MpLeNameValueNode,
	#superclass : #MpLeEntityParseNode,
	#instVars : [
		'value',
		'name',
		'equals'
	],
	#category : #'MyPeople-GToolkit'
}

{ #category : #generated }
MpLeNameValueNode >> acceptVisitor: anEntityParseVisitor [

	^ anEntityParseVisitor visitNameValue: self
]

{ #category : #generated }
MpLeNameValueNode >> equals [

	^ equals
]

{ #category : #generated }
MpLeNameValueNode >> equals: aSmaCCToken [

	equals := aSmaCCToken
]

{ #category : #generated }
MpLeNameValueNode >> name [

	^ name
]

{ #category : #generated }
MpLeNameValueNode >> name: aSmaCCToken [

	name := aSmaCCToken
]

{ #category : #generated }
MpLeNameValueNode >> tokenVariables [

	^ #( #value #name #equals )
]

{ #category : #generated }
MpLeNameValueNode >> value [

	^ value
]

{ #category : #generated }
MpLeNameValueNode >> value: aSmaCCToken [

	value := aSmaCCToken
]
