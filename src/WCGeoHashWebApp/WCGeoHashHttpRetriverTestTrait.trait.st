Trait {
	#name : #WCGeoHashHttpRetriverTestTrait,
	#instVars : [
		'server',
		'db',
		'id',
		'gh',
		'retriever',
		'url',
		'ghIndex'
	],
	#category : #'WCGeoHashWebApp-Tests'
}

{ #category : #tests }
WCGeoHashHttpRetriverTestTrait >> testAddressOfId [

	retriever baseUrl: url.
	self assert: (retriever addressOfId: id) stringAddress equals: gh stringAddress
]

{ #category : #tests }
WCGeoHashHttpRetriverTestTrait >> testGetIndexAt [

	retriever baseUrl: url.
	self
		assert: (retriever getIndexAt: ghIndex) size
		equals: 1
]

{ #category : #tests }
WCGeoHashHttpRetriverTestTrait >> testGetObjectAtId [

	 retriever baseUrl: url.
	self assert: (retriever getObjectAtId: id) equals: 'Random stuff'
]
