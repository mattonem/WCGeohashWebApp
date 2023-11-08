"
A WCGeoHashHttpRetriverTest is a test class for testing the behavior of WCGeoHashHttpRetriver
"
Class {
	#name : #WCGeoHashHttpRetriverTest,
	#superclass : #TestCase,
	#traits : 'WCGeoHashHttpRetriverTestTrait',
	#classTraits : 'WCGeoHashHttpRetriverTestTrait classTrait',
	#category : #'WCGeoHash-Tests'
}

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriverTest >> setUp [

	| folder |
	super setUp.
	folder := FileLocator workingDirectory / 'dbTest2'.
	folder ensureDeleteAll.
	folder ensureCreateDirectory.
	db := WCGeoHashDB new rootFolder: folder.
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: (db getIndexAt: gh) size equals: 0.
	id := '123'.

	db write: 'Random stuff' id: id geoHash: gh.
	retriever := WCGeoHashHttpRetriver new.
	server := ZnServer startOn: 1234.
	server delegate: (ZnStaticFileServerDelegate new
			 directory: folder;
			 yourself).
	url := server url.
	ghIndex := WCGeoHash fromString: 'e'
]
