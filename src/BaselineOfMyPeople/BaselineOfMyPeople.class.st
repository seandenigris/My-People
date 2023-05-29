Class {
	#name : #BaselineOfMyPeople,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyPeople
}

{ #category : #testing }
BaselineOfMyPeople class >> isDynabook [
	^ true
]

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
			baseline: 'NeoCSV' with: [
				spec 
					repository: 'github://seandenigris/NeoCSV';
					loads: 'Neo-CSV-Magritte' ];
			baseline: 'PharoEnhancements' with: [
				spec 
					repository: 'github://seandenigris/Pharo-Enhancements';
					loads: #(#default 'PharoEnhancements-Magritte') ];
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ].
		spec package: #MyPeople with: [
			spec requires: #('Magritte' 'Mocketry' 'NeoCSV' 'PharoEnhancements' 'SimplePersistence'). ]. ].
				
	spec for: #GToolkit do: [ 
		spec baseline: 'ObjectiveLepiter' with: [
			spec repository: 'github://seandenigris/Objective-Lepiter' ].
		spec package: #MyPeople with: [
			spec requires: #('ObjectiveLepiter') ] ].
	
	spec for: #notGToolkit do: [ 
		spec baseline: 'PetitParser2' with: [
			spec repository: 'github://seandenigris/PetitParser2' ].
		spec package: #MyPeople with: [
			spec requires: #('PetitParser2'). ] ]
]

{ #category : #accessing }
BaselineOfMyPeople >> customProjectAttributes [
	^ self isGTImage
			ifFalse: [ #(notGToolkit) ]
			ifTrue: [ #(GToolkit) ]
]

{ #category : #testing }
BaselineOfMyPeople >> isGTImage [
	
	^ RPackageOrganizer default packageNames anySatisfy: [ :pn | pn beginsWith: 'Lepiter-' ].
	"Implementation note: used to check for GToolkit prefix, but P7 has a GToolkit-Examples package. Lepiter, OTOH, could only be loaded in a GT image"
]
