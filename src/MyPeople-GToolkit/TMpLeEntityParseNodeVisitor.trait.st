Trait {
	#name : #TMpLeEntityParseNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'MyPeople-GToolkit'
}

{ #category : #generated }
TMpLeEntityParseNodeVisitor >> visitEntityAnnotation: anEntityAnnotation [

	^ self visitEntityParse: anEntityAnnotation
]

{ #category : #generated }
TMpLeEntityParseNodeVisitor >> visitEntityParse: anEntityParse [

	^ self visitSmaCCParseNode: anEntityParse
]

{ #category : #generated }
TMpLeEntityParseNodeVisitor >> visitNameValue: aNameValue [

	^ self visitEntityParse: aNameValue
]