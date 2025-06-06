Class {
	#name : #MpMunicipality,
	#superclass : #MpOrganization,
	#instVars : [
		'cache'
	],
	#category : #'MyPeople-Core'
}

{ #category : #accessing }
MpMunicipality >> buildingFootprints [

	^ self cache
		at: #buildingFootprints 
		ifAbsentPut: [ self buildingFootprintsGet ]
]

{ #category : #'as yet unclassified' }
MpMunicipality >> cache [

	^ cache ifNil: [ cache := RlCache new ]
]

{ #category : #testing }
MpMunicipality >> isMunicipality [
	^ true
]

{ #category : #accessing }
MpMunicipality >> parcels [

	^ self cache
		at: #parcels 
		ifAbsentPut: [ self parcelsGet ]
]

{ #category : #accessing }
MpMunicipality >> propertyAddresses [

	^ self propertyAt: #propertyAddresses
]

{ #category : #accessing }
MpMunicipality >> propertyAddresses: aCollection [

	^ self 
		propertyAt: #propertyAddresses
		putRemovingNil: aCollection
]

{ #category : #accessing }
MpMunicipality >> propertyAddressesFromParcels [

	^ self
		propertyAt: #propertyAddressesFromParcels
		ifAbsentPut: [ 
			| addressParcels |
			addressParcels := self parcels select: #isAddress.
			addressParcels collect: #canonicalAddress. ]
]
