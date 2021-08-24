Class {
	#name : 'MyPeopleDB',
	#superclass : 'SpFileDatabase',
	#category : 'MyPeople-Persistence'
}

{ #category : 'accessing' }
MyPeopleDB class >> backupDirectoryParent [
	^ FileLocator dynabookData
]

{ #category : 'loading/saving' }
MyPeopleDB class >> schema [

	^ { MpAddressBook }.
]
