Class {
	#name : #WCGeoHashDB,
	#superclass : #Object,
	#instVars : [
		'rootFolder'
	],
	#category : #WCGeoHash
}

{ #category : #accessing }
WCGeoHashDB >> addToIndexAt: aWCGeoHash id: aString [

	| index |
	aWCGeoHash precision = 0 ifTrue: [ ^ self ].
	index := self getIndexAt: aWCGeoHash.
	index add: aString.
	self writeIndex: index at: aWCGeoHash.
	self addToIndexAt: aWCGeoHash parent id: aString
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> addressOfId: aString [

	^ (STON fromString: (self objectFolder / (aString , '.ston')) readStream contents)
		  at: #address
]

{ #category : #writing }
WCGeoHashDB >> deleteId: anId [

	| aGh |
	aGh := self addressOfId: anId.
	(self objectFolder / (anId , '.ston')) ensureDelete.
	self removeFromIndex: anId geoHash: aGh
]

{ #category : #accessing }
WCGeoHashDB >> getIndexAt: aWCGeoHash [

	(rootFolder / (aWCGeoHash stringAddress , '.ston')) ensureCreateFile.
	^ (rootFolder / (aWCGeoHash stringAddress , '.ston')) readStream contents
		  ifEmpty: [ OrderedCollection new ]
		  ifNotEmpty: [ :c | STONJSON fromString: c ]
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> getObjectAtId: aString [

	^ (STON fromString: (self objectFolder / (aString , '.ston')) readStream contents)
		  at: #data
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> objectFolder [
	^ rootFolder / 'objects'
]

{ #category : #removing }
WCGeoHashDB >> removeFromIndex: aString geoHash: aWCGeoHash [

	| index |
	aWCGeoHash precision = 0 ifTrue: [ ^ self ].
	index := self getIndexAt: aWCGeoHash.
	index remove: aString.
	self writeIndex: index at: aWCGeoHash.
	self removeFromIndex: aString geoHash: aWCGeoHash parent
]

{ #category : #accessing }
WCGeoHashDB >> rootFolder: anObject [

	rootFolder := anObject
]

{ #category : #writing }
WCGeoHashDB >> update: anObject id: aString2 [ 
	| aWCGeoHash |
	aWCGeoHash := self addressOfId: aString2.
	self writeObject: anObject id: aString2 geoHash: aWCGeoHash.
]

{ #category : #writing }
WCGeoHashDB >> write: anObject id: aString2 geoHash: aWCGeoHash [

	self writeObject: anObject id: aString2 geoHash: aWCGeoHash.
	self addToIndexAt: aWCGeoHash id: aString2
]

{ #category : #writing }
WCGeoHashDB >> writeIndex: aCollection at: aWCGeoHash [

	(rootFolder / (aWCGeoHash stringAddress , '.ston')) ensureDelete.
	(rootFolder / (aWCGeoHash stringAddress , '.ston')) ensureCreateFile.
	rootFolder / (aWCGeoHash stringAddress , '.ston') writeStreamDo: [ :s |
		(STONWriter on: s) nextPut: aCollection ]
]

{ #category : #writing }
WCGeoHashDB >> writeObject: anObject id: aString2 geoHash: aGeoHash [

	(self objectFolder / (aString2 , '.ston')) ensureDelete.
	(self objectFolder / (aString2 , '.ston')) ensureCreateFile.
	self objectFolder / (aString2 , '.ston') writeStreamDo: [ :s |
		(STONWriter on: s) nextPut: {
				(#data -> anObject).
				(#address -> aGeoHash) } asDictionary ]
]
