Class {
	#name : #MpGoogleContactsWriter,
	#superclass : #MACSVWriter,
	#category : #'MyPeople-Google'
}

{ #category : #accessing }
MpGoogleContactsWriter >> fieldNamePropertyKey [
	"The property where the element description stores the field name; override to customize"

	^ #googleCsvFieldName
]
