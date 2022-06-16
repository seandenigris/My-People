Class {
	#name : #MpLeEntityAnnotationCompletionVisitor,
	#superclass : #Object,
	#traits : 'TSmaCCComponentVisitor + (TMpLeEntityParseNodeVisitor - {#acceptNode:})',
	#classTraits : 'TSmaCCComponentVisitor classTrait + TMpLeEntityParseNodeVisitor classTrait',
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor class >> activate [
	LeContentCompletionVisitor additionalCompletionVisitors add: self
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor class >> initialize [
	self activate
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor class >> obsolete [
	LeContentCompletionVisitor additionalCompletionVisitors remove: self ifAbsent: [  ].
	^ super obsolete
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor >> addStreamFor: words startingWith: prefix [
	^ self composite
		addStream:
			((words asyncStreamStartingWith: prefix)
				collect:
					[ :each | 
					GtInsertTextCompletionAction
						labeled: each
						completion: (each allButFirst: prefix size)
						position: self composite position ])
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor >> position [
	^ self composite position
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor >> visitArgument: anArgument [
	^ self visitEntityParse: anArgument
]

{ #category : #generated }
MpLeEntityAnnotationCompletionVisitor >> visitEntityAnnotation: anEntityAnnotation [
	"Halt once".
	"^ self addStreamFor: (GtPrefixTree add:'Tim1'; add: 'Tom2'; add: 'Toe3'; yourself) startingWith: ''."
	^ self visitEntityParse: anEntityAnnotation
]

{ #category : #generated }
MpLeEntityAnnotationCompletionVisitor >> visitNameValue: aNameValue [
	| first last completion isCursorInside |
	first := aNameValue valueStartPosition.
	last := aNameValue stopPosition + 1.
	
	isCursorInside := self position >= first and: [ self position < last ].
	isCursorInside ifFalse: [ ^ self visitArgument: aNameValue ].
			
	completion := MpEntityCompletionResult forInterval: (first to: last).
	^ self composite completionResult: completion
]
