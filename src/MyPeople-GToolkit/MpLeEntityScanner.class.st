Class {
	#name : #MpLeEntityScanner,
	#superclass : #SmaCCScanner,
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #'generated-initialization' }
MpLeEntityScanner class >> initializeKeywordMap [

	keywordMap := Dictionary new.
	#( #( 4 'name' 2 ) ) do: [ :each | 
		(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
			at: (each at: 2)
			put: each last ].
	^ keywordMap
]

{ #category : #generated }
MpLeEntityScanner >> emptySymbolTokenId [

	^ 11
]

{ #category : #generated }
MpLeEntityScanner >> errorTokenId [

	^ 12
]

{ #category : #generated }
MpLeEntityScanner >> scanForToken [

	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #( 1 ) ].
	currentCharacter == $| ifTrue: [ ^ self recordAndReportMatch: #( 3 ) ].
	currentCharacter isLetter ifTrue: [ 
		[ 
		self recordMatch: #( 4 ).
		self step.
		currentCharacter isLetter ] whileTrue ].
	^ self reportLastMatch
]
