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
WCGeoHashHttpRetriver >> getObjectAtId: aString [

	^ (PhxJsonReader readFromString:
		   (self getClient get:
			    (self objectUrl withPath: aString , '.json'))) at: #data
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
			aBlock value: (content at: #address) value: (content at: #data) ]
]

{ #category : #accessing }
WCGeoHashHttpRetriver >> getObjectsIn: aGh do: aBlock [

	self getIndexAt: aGh do: [ :ids |
		ids do: [ :id |
			self getObjectAtId: id do: aBlock ] ]
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
