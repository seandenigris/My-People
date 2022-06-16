Class {
	#name : #MpLeEntityAnnotationNode,
	#superclass : #MpLeEntityParseNode,
	#instVars : [
		'items',
		'bars'
	],
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #generated }
MpLeEntityAnnotationNode >> acceptVisitor: anEntityParseVisitor [

	^ anEntityParseVisitor visitEntityAnnotation: self
]

{ #category : #generated }
MpLeEntityAnnotationNode >> bars [

	^ bars
]

{ #category : #generated }
MpLeEntityAnnotationNode >> bars: anOrderedCollection [

	bars := anOrderedCollection
]

{ #category : #generated }
MpLeEntityAnnotationNode >> compositeNodeVariables [

	^ #( #items )
]

{ #category : #generated }
MpLeEntityAnnotationNode >> compositeTokenVariables [

	^ #( #bars )
]

{ #category : #'generated-initialize-release' }
MpLeEntityAnnotationNode >> initialize [
	super initialize.
	items := OrderedCollection new: 2.
	bars := OrderedCollection new: 2.
]

{ #category : #generated }
MpLeEntityAnnotationNode >> items [

	^ items
]

{ #category : #generated }
MpLeEntityAnnotationNode >> items: anOrderedCollection [

	self setParents: self items to: nil.
	items := anOrderedCollection.
	self setParents: self items to: self
]

{ #category : #accessing }
MpLeEntityAnnotationNode >> object [
	^ DbSoup detectUIDString36: self uid
]

{ #category : #accessing }
MpLeEntityAnnotationNode >> uid [
	^ self items
		detect: [ :e | e isKindOf: MpLeUIDArgumentNode ]
		ifFound: [ :uidArg | uidArg uid ]
		ifNone: [ nil ]
]
