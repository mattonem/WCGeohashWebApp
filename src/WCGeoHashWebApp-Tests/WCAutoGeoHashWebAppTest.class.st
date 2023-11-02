Class {
	#name : #WCAutoGeoHashWebAppTest,
	#superclass : #PjWebAppTestCase,
	#traits : 'PjTAppRunsInJS',
	#classTraits : 'PjTAppRunsInJS classTrait',
	#category : #'WCGeoHashWebApp-Tests'
}

{ #category : #'suite parameters' }
WCAutoGeoHashWebAppTest class >> appClass [

	^ WCAutoGeoHashWebApp
]

{ #category : #accessing }
WCAutoGeoHashWebAppTest >> testGoTo [
	(self app document querySelector: '#lon') value: 0.
	(self app document querySelector: '#lat') value: 0.
	(self app document querySelector: '#goTo') click.
	(self app document querySelector: '#calculate') click.
	self
		assert: ((self app document querySelector: '#result') innerHTML trim splitOn: ' ') size
		> 1
]
