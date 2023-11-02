Class {
	#name : #WCGeoHashWebAppTest,
	#superclass : #PjWebAppTestCase,
	#traits : 'PjTAppRunsInJS',
	#classTraits : 'PjTAppRunsInJS classTrait',
	#category : #'WCGeoHashWebApp-Tests'
}

{ #category : #'suite parameters' }
WCGeoHashWebAppTest class >> appClass [

	^ WCGeoHashWebApp 
]

{ #category : #accessing }
WCGeoHashWebAppTest >> testGoTo [

	(self app document querySelector: '#lon') value: 0.
	(self app document querySelector: '#lat') value: 0.
	(self app document querySelector: 'button') click.
	self
		assert: (self app document querySelector: '#result') innerHTML
		equals: 's0000'
	
]
