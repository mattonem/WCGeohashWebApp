"
A WCGeoHashHttpRetriverTest is a test class for testing the behavior of WCGeoHashHttpRetriver
"
Class {
	#name : #WCGeoHashHttpRetriverTest,
	#superclass : #TestCase,
	#instVars : [
		'gh',
		'id',
		'server',
		'db'
	],
	#category : #'WCGeoHash-Tests'
}

{ #category : #test }
WCGeoHashHttpRetriverTest >> setUp [

	| folder db |
	super setUp.
	folder := FileLocator workingDirectory / 'dbTest2'.
	folder ensureDeleteAll.
	folder ensureCreateDirectory.
	db := WCGeoHashDB new rootFolder: folder.
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: (db getIndexAt: gh) size equals: 0.
	id := '123'.
	db write: 'Random stuff' id: id geoHash: gh.
	server := ZnServer startDefaultOn: 1701.
	server delegate: (ZnStaticFileServerDelegate new directory: folder ; yourself)
]

{ #category : #test }
WCGeoHashHttpRetriverTest >> testGetIndexAt [

	db := WCGeoHashHttpRetriver new baseUrl: server url.
	self assert: (db getIndexAt: (WCGeoHash fromString: 'e')) size equals: 1
]

{ #category : #test }
WCGeoHashHttpRetriverTest >> testGetObjectAtId [

	db := WCGeoHashHttpRetriver new baseUrl: server url.
	self
		assert: (db getObjectAtId:  id) 
		equals: 'Random stuff'
]
