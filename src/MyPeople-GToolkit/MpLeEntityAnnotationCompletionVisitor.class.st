Class {
	#name : #MpLeEntityAnnotationCompletionVisitor,
	#superclass : #Object,
	#traits : 'TSmaCCComponentVisitor + (TMpLeEntityParseNodeVisitor - {#acceptNode:})',
	#classTraits : 'TSmaCCComponentVisitor classTrait + TMpLeEntityParseNodeVisitor classTrait',
	#category : #'MyPeople-GToolkit'
}

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor class >> activate [
	LeContentCompletionVisitor additionalCompletionVisitors add: self
]

{ #category : #accessing }
MpLeEntityAnnotationCompletionVisitor class >> initialize [
	"WIP - not ready to enable by default"
	"self activate"
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

{ #category : #generated }
MpLeEntityAnnotationCompletionVisitor >> visitEntityAnnotation: anEntityAnnotation [
	"Halt once".
	"^ self addStreamFor: (GtPrefixTree add:'Tim1'; add: 'Tom2'; add: 'Toe3'; yourself) startingWith: ''."
	^ self visitEntityParse: anEntityAnnotation
]

{ #category : #generated }
MpLeEntityAnnotationCompletionVisitor >> visitNameValue: aNameValue [
	"Halt once."
	^ self addStreamFor: (GtPrefixTree new add:'Tim'; add: 'Tom'; add: 'Toe'; yourself) startingWith: ''."
	^ self visitEntityParse: aNameValue"
]
