Extension { #name : #ByteString }

{ #category : #'*MyPeople' }
ByteString >> mpAsCanonicalName [
	"A standard string to compare against another name, and accounting for possible initials"

	^ (self asLowercase capitalized copyWithout: ' ') trimRight: [ :c | c = $. ]
]

{ #category : #'*MyPeople' }
ByteString >> mpAsGenerational [
	^ MpGenerational fromString: self
]
