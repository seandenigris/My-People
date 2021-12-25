Class {
	#name : #MpLeEntityNode,
	#superclass : #SmaCCParseNode,
	#instVars : [
		'value',
		'name',
		'equals'
	],
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #generated }
MpLeEntityNode >> acceptVisitor: anEntityVisitor [

	^ anEntityVisitor visitEntity: self
]

{ #category : #generated }
MpLeEntityNode >> equals [

	^ equals
]

{ #category : #generated }
MpLeEntityNode >> equals: aSmaCCToken [

	equals := aSmaCCToken
]

{ #category : #generated }
MpLeEntityNode >> name [

	^ name
]

{ #category : #generated }
MpLeEntityNode >> name: aSmaCCToken [

	name := aSmaCCToken
]

{ #category : #generated }
MpLeEntityNode >> tokenVariables [

	^ #( #value #name #equals )
]

{ #category : #generated }
MpLeEntityNode >> value [

	^ value
]

{ #category : #generated }
MpLeEntityNode >> value: aSmaCCToken [

	value := aSmaCCToken
]
