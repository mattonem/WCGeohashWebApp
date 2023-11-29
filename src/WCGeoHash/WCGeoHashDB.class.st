Class {
	#name : #WCGeoHashDB,
	#superclass : #Object,
	#instVars : [
		'rootFolder',
		'coords',
		'precision',
		'ids'
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

	^ WCGeoHash hashFor:((self getObjectAtId: aString) at: coords) precision: precision.
]

{ #category : #enumerating }
WCGeoHashDB >> allObjectsDo: aFullBlockClosure [

	self objectFolder allFiles do: [ :aFile |
		aFullBlockClosure value:
			((PhxJsonReader readFromString: aFile readStream contents) ) ]
]

{ #category : #accessing }
WCGeoHashDB >> coords: anObject [

	coords := anObject
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> createIndex [
	self allObjectsDo: [ :object |
		| aGh |
		aGh := WCGeoHash hashFor: (object at: coords) precision: precision.
		self addToIndexAt: aGh id: (object at: ids) ]
]

{ #category : #writing }
WCGeoHashDB >> deleteId: anId [

	| aGh |
	aGh := self addressOfId: anId.
	(self objectFolder / (anId , '.ston')) ensureDelete.
	self removeFromIndex: anId geoHash: aGh
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> deleteIndex [
	rootFolder files do: [ :aFile | aFile delete ]
]

{ #category : #accessing }
WCGeoHashDB >> getIndexAt: aWCGeoHash [

	(rootFolder / (aWCGeoHash stringAddress , '.json')) ensureCreateFile.
	^ (rootFolder / (aWCGeoHash stringAddress , '.json')) readStream
		  contents
		  ifEmpty: [ OrderedCollection new ]
		  ifNotEmpty: [ :c | PhxJsonReader readFromString: c ]
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> getObjectAtId: aString [

	^ (PhxJsonReader readFromString:
		   (self objectFolder / (aString , '.json')) readStream contents)

]

{ #category : #accessing }
WCGeoHashDB >> ids: anObject [

	ids := anObject
]

{ #category : #writing }
WCGeoHashDB >> initialize [

	super initialize.
	precision := 7.
	coords := #coordinates.
	ids := #id
]

{ #category : #'as yet unclassified' }
WCGeoHashDB >> objectFolder [
	^ rootFolder / 'objects'
]

{ #category : #accessing }
WCGeoHashDB >> precision: anObject [

	precision := anObject
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
WCGeoHashDB >> write: anObject [ 

 | id coordinates |
id := ((anObject respondsTo: ids) ifTrue: [anObject perform: ids] ifFalse:[anObject at: ids]).
coordinates := ((anObject respondsTo: coords) ifTrue: [anObject perform: coords] ifFalse:[anObject at: coords]).

	self writeObject: anObject id: id geoHash: (WCGeoHash hashFor: coordinates precision: precision) .
	self addToIndexAt: (WCGeoHash hashFor: coordinates precision: precision) id: id
]

{ #category : #writing }
WCGeoHashDB >> writeIndex: aCollection at: aWCGeoHash [

	(rootFolder / (aWCGeoHash stringAddress , '.json')) ensureDelete.
	(rootFolder / (aWCGeoHash stringAddress , '.json')) ensureCreateFile.
	rootFolder / (aWCGeoHash stringAddress , '.json') writeStreamDo: [ :s |
		s nextPutAll: aCollection asPhxJsonString  ]
]

{ #category : #writing }
WCGeoHashDB >> writeObject: anObject id: aString2 geoHash: aGeoHash [

	(self objectFolder / (aString2 , '.json')) ensureDelete.
	(self objectFolder / (aString2 , '.json')) ensureCreateFile.
	self objectFolder / (aString2 , '.json') writeStreamDo: [ :s |
		s nextPutAll: anObject asPhxJsonString ]
]
