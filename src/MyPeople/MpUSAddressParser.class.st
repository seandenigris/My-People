Class {
	#name : #MpUSAddressParser,
	#superclass : #MpUSAddressGrammar,
	#category : #MyPeople
}

{ #category : #'as yet unclassified' }
MpUSAddressParser >> directional [

	^ super directional ==> [ :aString |
		MpUSAddress 
			normalizeToken: aString
			withMap: MpUSAddress directionalMap ]
]

{ #category : #'as yet unclassified' }
MpUSAddressParser >> parser [

	^ super parser ==> [ :nodes |
		| tokens |
		tokens := Array streamContents: [ :str |
			str nextPut: nodes first capitalized.
			nodes second ifNotNil: [ :preDir |
				str nextPut: preDir second capitalized ].
			str nextPut: nodes fourth second capitalized; nextPut: nodes sixth capitalized.
			nodes seventh ifNotNil: [ :postDir |
				str nextPut: postDir second capitalized ].
			nodes eighth ifNotNil: [ :secAdd |
				str nextPut: secAdd second capitalized ] ].
		tokens joinUsing: Character space ].
]

{ #category : #'as yet unclassified' }
MpUSAddressParser >> suffix [

	^ super suffix ==> [ :aString |
		MpUSAddress 
			normalizeToken: aString 
			withMap: MpUSAddress streetSuffixMap. ]
]
