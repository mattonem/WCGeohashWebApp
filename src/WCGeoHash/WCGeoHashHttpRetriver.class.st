Class {
	#name : #WCGeoHashHttpRetriver,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'client'
	],
	#category : #WCGeoHash
}

{ #category : #accessing }
WCGeoHashHttpRetriver >> addressOfId: aString [

	^ (PhxJsonReader readFromString:
		   (self getClient get:
			    (self objectUrl withPath: aString , '.json'))) at: #address
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> baseUrl: anObject [

	baseUrl := anObject.
	
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> getClient [

	^ client ifNil: [ client := self newHttpClient ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getIndexAt: anAddress [

	^ PhxJsonReader readFromString: (self getClient get:
			   (baseUrl withPath: anAddress stringAddress , '.json'))
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getObjectAtId: aString [

	^ (PhxJsonReader readFromString:
		   (self getClient get:
			    (self objectUrl withPath: aString , '.json'))) at: #data
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> newHttpClient [

	<javascript: 'return this.pj_newJSHttpClient()'>
	^ ZnClient new
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> newJSHttpClient [

	^ PjHttpClient new
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> objectUrl [

	^ baseUrl withPath: 'objects'
]
