"
A WCGeoHashDBTest is a test class for testing the behavior of WCGeoHashDB
"
Class {
	#name : #WCGeoHashDBTest,
	#superclass : #TestCase,
	#instVars : [
		'db'
	],
	#category : #'WCGeoHash-Tests'
}

{ #category : #running }
WCGeoHashDBTest >> setUp [
	|folder|
	super setUp.
	folder := FileLocator workingDirectory / 'dbTest'.
	folder ensureDeleteAll.
	folder ensureCreateDirectory.
	db := WCGeoHashDB new rootFolder: folder
]

{ #category : #test }
WCGeoHashDBTest >> testDeleteId [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	db write: 'Random stuff' id: '123' geoHash: gh.
	db deleteId: '123'.
	self assert: (db getIndexAt: gh) size equals: 0.
	self assert: (db getIndexAt: gh parent)  size equals: 0
]

{ #category : #test }
WCGeoHashDBTest >> testWriteIdGeoHash [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: (db getIndexAt: gh) size equals: 0.
	db write: 'Random stuff' id: '123' geoHash: gh.
	self assert: (db getIndexAt: gh) size equals: 1.
	self assert: (db getIndexAt: gh parent) size equals: 1.
	self assert: (db getObjectAtId: '123') equals: 'Random stuff'
]
