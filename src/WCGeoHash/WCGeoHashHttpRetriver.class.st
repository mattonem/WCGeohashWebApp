Class {
	#name : #WCGeoHashHttpRetriver,
	#superclass : #Object,
	#instVars : [
		'baseUrl'
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

	^ self newHttpClient 
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getIndexAt: anAddress [

	| client |
	client := self getClient.
	client get: (baseUrl copy withPath: anAddress stringAddress , '.json').
	^ client response code = 200
		  ifTrue: [ PhxJsonReader readFromString: client response contents ]
		  ifFalse: [ {  } ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getIndexAt: anAddress do: aBlock [

	| client req |
	client := self getClient.
	client onLoad: [ :event |
		event currentTarget status = 200
			ifTrue: [
				aBlock value:
					(PhxJsonReader readFromString: event currentTarget responseText) ]
			ifFalse: [  ] ].
		req := client method:'GET' url: (baseUrl copy withPath: anAddress stringAddress , '.json').
		req send:''
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

	<ignoreForCoverage>
	^ PjHttpClient new
]

{ #category : #'as yet unclassified' }
WCGeoHashHttpRetriver >> objectUrl [

	^ baseUrl withPath: 'objects'
]
