Class {
	#name : #WCGeoHashHttpRetriver,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'coords',
		'precision',
		'ids'
	],
	#category : #WCGeoHash
}

{ #category : #accessing }
WCGeoHashHttpRetriver >> baseUrl: anObject [

	baseUrl := anObject.
	
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> getClient [

	^ self newHttpClient 
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getIndexAt: anAddress do: aBlock [

	| client |
	client := self getClient.
	client
		getUrl: (baseUrl withPath: anAddress stringAddress , '.json')
		do: [ :response :status |
			status = 200
				ifTrue: [ aBlock value: (PhxJsonReader readFromString: response) ]
				ifFalse: [  ] ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getObjectAtId: aString do: aBlock [

	| client |
	client := self getClient.
	client
		getUrl: (self objectUrl withPath: aString , '.json') asString
		do: [ :responseText :status |
			| content |
			content := PhxJsonReader readFromString: responseText.
			aBlock value: content ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getObjectsIn: aGh do: aBlock [

	self
		getIndexAt: aGh
		do: [ :allIds | allIds do: [ :id | self getObjectAtId: id do: aBlock ] ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> initialize [

	super initialize.
	precision := 7.
	coords := #coordinates.
	ids := #id
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> newHttpClient [

^ PjHttpClient new
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> objectUrl [

	^ baseUrl withPath: 'objects'
]
