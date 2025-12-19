Class {
	#name : 'MyPeopleDB',
	#superclass : 'SpFileDatabase',
	#category : 'MyPeople-Persistence',
	#package : 'MyPeople',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
MyPeopleDB class >> backupDirectoryParent [
	^ FileLocator dynabookData
]

{ #category : 'loading/saving' }
MyPeopleDB class >> schema [

	^ { MpAddressBook }.
]
