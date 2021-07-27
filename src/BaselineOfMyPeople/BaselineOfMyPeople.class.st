Class {
	#name : #BaselineOfMyPeople,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyPeople
}

{ #category : #baseline }
BaselineOfMyPeople >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: 'Magritte' with: [
				spec 
					loads: #('Magritte-Merging');
					repository: 'github://seandenigris/Magritte' ];
			baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry' ];
			baseline: 'PharoEnhancements' with: [
				spec repository: 'github://seandenigris/Pharo-Enhancements' ];
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ].
		spec package: #MyPeople with: [
				spec requires: #('Magritte' 'Mocketry' 'PetitParser2' 'PharoEnhancements' 'SimplePersistence'). ]. ].
				
	spec for: #notGToolkit do: [ 
		spec
			baseline: 'PetitParser2' with: [
				spec repository: 'github://seandenigris/PetitParser2' ] ]

]

{ #category : #accessing }
BaselineOfMyPeople >> customProjectAttributes [
	^ self isGTImage
			ifFalse: [ #(notGToolkit) ]
			ifTrue: [ #(GToolkit) ]
]

{ #category : #testing }
BaselineOfMyPeople >> isGTImage [
	^ RPackageOrganizer default packageNames anySatisfy: [ :pn | pn beginsWith: 'GToolkit-' ]
]
