Class {
	#name : #MpLeEntityAnnotationStyler,
	#superclass : #LeComponentStyler,
	#traits : 'TMpLeEntityParseNodeVisitor',
	#classTraits : 'TMpLeEntityParseNodeVisitor classTrait',
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #accessing }
MpLeEntityAnnotationStyler class >> activate [
	LeSnippetStylerVisitor additionalStylers add: self
]

{ #category : #accessing }
MpLeEntityAnnotationStyler class >> initialize [
	"WIP - not ready to enable by default"
	"self activate"
]

{ #category : #accessing }
MpLeEntityAnnotationStyler class >> obsolete [
	LeSnippetStylerVisitor additionalStylers remove: self ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
MpLeEntityAnnotationStyler >> styleAnnotation: anEntityAnnotation [
	"Add styling for the actual markup"
	| aLinkColor |
	aLinkColor := false
		ifTrue: [ BrGlamorousColors textMarkupColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ].
	(self composite text from: anEntityAnnotation parent startPosition to: anEntityAnnotation parent stopPosition) foreground: aLinkColor
]

{ #category : #generated }
MpLeEntityAnnotationStyler >> styleAutoHidingAnnotation: anAnnotation [
	"Add styling that hides the markup when it loses keyboard focus"
	| first last range |
	"anAnnotation hasWordSpecified ifFalse: [ ^ self ]."
	first := anAnnotation parent startPosition max: 1.
	last := anAnnotation parent stopPosition min: self composite text size.
	range := first to: last.
	composite
		styleAutoHiding: range
		and: range
		whenOutside: anAnnotation parent sourceInterval 
]

{ #category : #generated }
MpLeEntityAnnotationStyler >> styleButton: anAnnotation [
	"Add styling for the (in this case clickable) rendered markup"
	| attribute |
	"anAnnotation hasWordSpecified ifFalse: [ ^ self ]."
	attribute := (GtButtonAttribute new)
		beAppend;
		stencil:
				[ | button label |
					label := 'anAnnotation word'.
					button := LeSnippetStylerVisitor textLinkButtonPadding: (BlInsets top: 2) margin: BlInsets empty.
					button aptitude glamorousCodeFont.
					button
						beSmallSize;
						label: label;
						action: [ :aButton | aButton phlow spawnObject: ('self dictionary lookup: label') ].
					button ].
	self composite text
		attribute: attribute
		from: anAnnotation parent startPosition
		to: anAnnotation parent stopPosition
]

{ #category : #generated }
MpLeEntityAnnotationStyler >> visitEntityAnnotation: anEntityAnnotation [
	self styleAnnotation: anEntityAnnotation.
	"self styleAutoHidingAnnotation: anEntityAnnotation."
	self styleButton: anEntityAnnotation.
]
