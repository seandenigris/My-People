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
	self activate
]

{ #category : #accessing }
MpLeEntityAnnotationStyler class >> obsolete [
	LeSnippetStylerVisitor additionalStylers remove: self ifAbsent: [  ].
	^ super obsolete
]

{ #category : #private }
MpLeEntityAnnotationStyler >> styleAutoHiding: anAnnotation [
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

{ #category : #private }
MpLeEntityAnnotationStyler >> styleMarkup: anAnnotation [
	self utility
		subtleMarkupsInText: self text
		start: anAnnotation parent startPosition
		stop: anAnnotation parent stopPosition
]

{ #category : #private }
MpLeEntityAnnotationStyler >> styleRendered: anAnnotation [
	"Add styling for the (in this case clickable) rendered markup"
	| attribute |
	"anAnnotation hasWordSpecified ifFalse: [ ^ self ]."
	
	attribute := (GtButtonAttribute new)
		beAppend;
		stencil:
				[ | button label |
					label := anAnnotation object displayString.
					button := LeSnippetStylerVisitor textLinkButtonPadding: (BlInsets top: 2) margin: BlInsets empty.
					button aptitude glamorousCodeFont.
					button
						beSmallSize;
						label: label;
						action: [ :aButton | aButton phlow spawnObject: anAnnotation object ].
					button ].
	self composite text
		attribute: attribute
		from: anAnnotation parent startPosition
		to: anAnnotation parent stopPosition
]

{ #category : #accessing }
MpLeEntityAnnotationStyler >> text [
	^ self composite text
]

{ #category : #accessing }
MpLeEntityAnnotationStyler >> utility [
	^ GtDocumentUtility
]

{ #category : #generated }
MpLeEntityAnnotationStyler >> visitEntityAnnotation: anAnnotation [
	self styleMarkup: anAnnotation.
	self styleAutoHiding: anAnnotation.
	self styleRendered: anAnnotation
]
