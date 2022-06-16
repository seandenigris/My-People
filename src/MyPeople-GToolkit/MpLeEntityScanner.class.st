Class {
	#name : #MpLeEntityScanner,
	#superclass : #SmaCCScanner,
	#category : #'MyPeople-GToolkit-Lepiter-Annotation'
}

{ #category : #'generated-initialization' }
MpLeEntityScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(5 'name' 2) #(5 'uid' 3) #(6 'name' 2) #(6 'uid' 3))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
MpLeEntityScanner >> emptySymbolTokenId [
	^ 14
]

{ #category : #generated }
MpLeEntityScanner >> errorTokenId [
	^ 15
]

{ #category : #generated }
MpLeEntityScanner >> scanForToken [
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	currentCharacter == $| ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	currentCharacter isDigit
		ifTrue: [ [ self recordMatch: #(6).
			self step.
			currentCharacter isAlphaNumeric ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLetter
		ifTrue: [ [ self recordMatch: #(5 6).
			self step.
			currentCharacter isDigit
				ifTrue: [ [ self recordMatch: #(6).
					self step.
					currentCharacter isAlphaNumeric ] whileTrue.
					^ self reportLastMatch ].
			currentCharacter isLetter ] whileTrue ].
	^ self reportLastMatch
]
