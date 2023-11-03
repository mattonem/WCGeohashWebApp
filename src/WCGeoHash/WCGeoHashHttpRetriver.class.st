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

	^ (STONJSON fromString:
		   (self getClient get: self objectUrl / (aString , '.ston'))
			   utf8Decoded) at: #address.
			
		
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> baseUrl: anObject [

	baseUrl := anObject.
	
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> getClient [
	^ client ifNil: [ client := ZnClient new ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getIndexAt: anAddress [
	^ STONJSON fromString: (self getClient get:( baseUrl / (anAddress stringAddress , '.ston')) ) utf8Decoded
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getObjectAtId: aString [

	^ (STONJSON fromString:
		  (self getClient get: self objectUrl / (aString , '.ston'))
			  utf8Decoded) at: #data
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> objectUrl [
	^ baseUrl / 'objects'
]
