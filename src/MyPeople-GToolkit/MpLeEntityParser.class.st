Class {
	#name : #MpLeEntityParser,
	#superclass : #SmaCCGLRParser,
	#category : #'MyPeople-GToolkit'
}

{ #category : #initialization }
MpLeEntityParser class >> activate [
	LeParser annotationParsers
		at: 'mpEntity'
		put: [ :parser | parser spawnParser: self startingAt: self startingStateForEntityAnnotation ].
	MpLeEntityAnnotationStyler activate.
	MpLeEntityAnnotationCompletionVisitor activate
]

{ #category : #'generated-accessing' }
MpLeEntityParser class >> cacheId [
	^'2021-12-19T19:28:53.76871-05:00'
]

{ #category : #generated }
MpLeEntityParser class >> definitionComment [
"%glr;
%root EntityParse;
%prefix MpLe;
%suffix Node;

<name>
	: <isLetter>+
	;
EntityAnnotation 
	: Item 'item' (""|"" 'bar' Item 'item')* ""|"" 'bar'? {{}}
	;
Item
	: Name
	;
Name
	: (""name"" 'name' ""="" 'equals')? <name> 'value' {{NameValue}}
	| ""name"" 'value' {{NameValue}}
	;"
]

{ #category : #initialization }
MpLeEntityParser class >> initialize [
	"WIP - not ready to enable by default"
	"self activate"
]

{ #category : #initialization }
MpLeEntityParser class >> obsolete [
	LeParser annotationParsers removeKey: 'mpEntity' ifAbsent: [  ].
	^ super obsolete
]

{ #category : #generated }
MpLeEntityParser class >> reduceTable [
^#(
	#(10 1 #reduceActionForName3: 178179 false) 
	#(10 1 #reduceActionForName3: 178177 false) 
	#(8 0 #reduceActionFor______bar__Item__item___1: 116737 false) 
	#(9 1 #liftFirstValue: 161793 false) 
	#(6 2 #reduceActionForEntityAnnotation1: 82945 false) 
	#(10 3 #reduceActionForName2: 178178 false) 
	#(6 3 #reduceActionForEntityAnnotation2: 82946 false) 
	#(8 2 #reduceActionFor______bar__Item__item___2: 116738 false) 
	#(7 2 #reduceActionFor______bar__Item__item__1: 116737 false)
	).
]

{ #category : #generated }
MpLeEntityParser class >> scannerClass [
	^MpLeEntityScanner
]

{ #category : #generated }
MpLeEntityParser class >> startingStateForEntityAnnotation [

	^ 1
]

{ #category : #generated }
MpLeEntityParser class >> symbolNames [

	^ #( '"="' '"name"' '"|"' '<name>' 'B e g i n' 'EntityAnnotation'
	     '("|" ''bar'' Item ''item'')' '("|" ''bar'' Item ''item'')*'
	     'Item' 'Name' 'E O F' 'error' )
]

{ #category : #generated }
MpLeEntityParser class >> symbolTypes [

	^ #( #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #MpLeEntityAnnotationNode
	     #MpLeEntityAnnotationNode #OrderedCollection #OrderedCollection
	     #MpLeNameValueNode #MpLeNameValueNode #SmaCCToken #SmaCCErrorNode )
]

{ #category : #generated }
MpLeEntityParser class >> transitionTable [
^#(
#[1 0 9 0 2 0 13 0 4 0 17 0 6 0 21 0 9 0 21 0 10] 
#[1 0 29 0 1 0 6 0 3 0 6 0 11] 
#[0 0 10 0 3 0 11] 
#[0 0 0 0 11] 
#[1 0 14 0 3 0 33 0 8 0 14 0 11] 
#[0 0 18 0 3 0 11] 
#[0 0 37 0 4] 
#[1 0 41 0 3 0 45 0 7 0 22 0 11] 
#[0 0 26 0 3 0 11] 
#[1 0 9 0 2 0 13 0 4 0 49 0 9 0 49 0 10 0 30 0 11] 
#[0 0 34 0 3 0 11] 
#[0 0 38 0 3 0 11]
	).
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionForEntityAnnotation1: nodes [

	| result |
	result := MpLeEntityAnnotationNode new.
	result addNode: (nodes at: 1) to: result items.
	result addTokens: ((nodes at: 2) at: 1) to: result bars.
	result addNodes: ((nodes at: 2) at: 2) to: result items.
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionForEntityAnnotation2: nodes [

	| result |
	result := MpLeEntityAnnotationNode new.
	result addNode: (nodes at: 1) to: result items.
	result addTokens: ((nodes at: 2) at: 1) to: result bars.
	result addNodes: ((nodes at: 2) at: 2) to: result items.
	result addToken: (nodes at: 3) to: result bars.
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionForName2: nodes [

	| result |
	result := MpLeNameValueNode new.
	result name: (nodes at: 1).
	result equals: (nodes at: 2).
	result value: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionForName3: nodes [

	| result |
	result := MpLeNameValueNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionFor______bar__Item__item__1: nodes [

	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionFor______bar__Item__item___1: nodes [

	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
MpLeEntityParser >> reduceActionFor______bar__Item__item___2: nodes [

	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]
