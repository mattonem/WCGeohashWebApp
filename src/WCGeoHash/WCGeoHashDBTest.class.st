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

	| folder |
	super setUp.
	folder := FileLocator workingDirectory / 'dbTest'.
	folder ensureDeleteAll.
	folder ensureCreateDirectory.
	db := WCGeoHashDB new
		      rootFolder: folder;
		      coords: #coordinates;
		      precision: 7;
		      yourself
]

{ #category : #test }
WCGeoHashDBTest >> testCreateIndex [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	db write: {
			(#id -> '123').
			(#coordinates -> (9.9996 @ -4.329)).
			(#data -> 'some cool stuff') } asDictionary.
	self assert: (db getIndexAt: gh) size equals: 1.
	self assert: (db getIndexAt: gh parent) size equals: 1.
	db deleteIndex.
	self assert: (db getIndexAt: gh) size equals: 0.
	db createIndex.
	self assert: (db getIndexAt: gh) size equals: 1.
	self assert: (db getIndexAt: gh parent) size equals: 1
]

{ #category : #test }
WCGeoHashDBTest >> testDeleteId [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	db
		write: {
				(#id -> '123').
				(#coordinates -> (9.9996 @ -4.329)).
				(#data -> 'some cool stuff') } asDictionary.
	db deleteId: '123'.
	self assert: (db getIndexAt: gh) size equals: 0.
	self assert: (db getIndexAt: gh parent) size equals: 0
]

{ #category : #test }
WCGeoHashDBTest >> testDeleteIndex [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	db
		write: {
				(#id -> '123').
				(#coordinates -> (9.9996 @ -4.329)).
				(#data -> 'Random stuff') } asDictionary.
	self assert: (db getIndexAt: gh) size equals: 1.
	self assert: (db getIndexAt: gh parent) size equals: 1.
	db deleteIndex.
	self assert: (db getIndexAt: gh) size equals: 0.
	self
		assert: ((db getObjectAtId: '123') at: #data)
		equals: 'Random stuff'
]

{ #category : #test }
WCGeoHashDBTest >> testWriteIdGeoHash [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: (db getIndexAt: gh) size equals: 0.
	db
		write: {
				(#id -> '123').
				(#coordinates -> (9.9996 @ -4.329)).
				(#data -> 'Random stuff') } asDictionary.
	self assert: (db getIndexAt: gh) size equals: 1.
	self assert: (db getIndexAt: gh parent) size equals: 1.
	self
		assert: ((db getObjectAtId: '123') at: #data)
		equals: 'Random stuff'
]
