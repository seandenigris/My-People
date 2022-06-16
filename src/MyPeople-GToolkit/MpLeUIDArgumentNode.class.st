Class {
	#name : #MpLeUIDArgumentNode,
	#superclass : #MpLeEntityParseNode,
	#instVars : [
		'value',
		'name',
		'equals'
	],
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #generated }
MpLeUIDArgumentNode >> acceptVisitor: anEntityParseVisitor [
	^ anEntityParseVisitor visitUIDArgument: self
]

{ #category : #generated }
MpLeUIDArgumentNode >> equals [
	^ equals
]

{ #category : #generated }
MpLeUIDArgumentNode >> equals: aSmaCCToken [
	equals := aSmaCCToken
]

{ #category : #generated }
MpLeUIDArgumentNode >> name [
	^ name
]

{ #category : #generated }
MpLeUIDArgumentNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
MpLeUIDArgumentNode >> tokenVariables [
	^ #(#value #name #equals)
]

{ #category : #accessing }
MpLeUIDArgumentNode >> uid [
	^ self value value
]

{ #category : #generated }
MpLeUIDArgumentNode >> value [
	^ value
]

{ #category : #generated }
MpLeUIDArgumentNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
