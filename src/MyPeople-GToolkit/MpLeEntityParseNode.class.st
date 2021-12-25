Class {
	#name : #MpLeEntityParseNode,
	#superclass : #SmaCCParseNode,
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #generated }
MpLeEntityParseNode >> acceptVisitor: anEntityParseVisitor [

	^ anEntityParseVisitor visitEntityParse: self
]
