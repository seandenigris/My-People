Class {
	#name : #MpLeEntityParseNode,
	#superclass : #SmaCCParseNode,
	#category : #'MyPeople-GToolkit'
}

{ #category : #generated }
MpLeEntityParseNode >> acceptVisitor: anEntityParseVisitor [

	^ anEntityParseVisitor visitEntityParse: self
]
