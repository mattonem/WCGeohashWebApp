Trait {
	#name : #WCGeoHashHttpRetriverTestTrait,
	#instVars : [
		'server',
		'db',
		'id',
		'gh',
		'retriever',
		'url',
		'ghIndex',
		'result'
	],
	#category : #'WCGeoHash-Tests'
}

{ #category : #test }
WCGeoHashHttpRetriverTestTrait >> testGetObjectAtIdDo [

	retriever baseUrl: url.
	retriever
		getObjectAtId: id
		do: [ :object | result at: #object put: object ].
	self assert: ((result at: #object) at: #data) equals: 'some cool stuff'
]

{ #category : #test }
WCGeoHashHttpRetriverTestTrait >> testGetObjectsInDo [

	retriever baseUrl: url.

	retriever
		getObjectsIn: gh
		do: [ :object | result at: #object put: object ].
	self
		assert: ((result at: #object) at: #data)
		equals: 'some cool stuff'
]
