Class {
	#name : #WCGeoHashWebTest,
	#superclass : #PjBridgeTestCase,
	#category : #'WCGeoHashWebApp-Tests'
}

{ #category : #tests }
WCGeoHashWebTest >> testAssertEquivalent [

	self assertEquivalent: [
		(WCGeoHash hashFor: 0 @ 0 precision: 5) stringAddress ].
	self assertEquivalent: [
		(WCGeoHash hashFor: 0 @ 0 precision: 5) north stringAddress ].
	self assertEquivalent: [
		(WCGeoHash hashFor: 0 @ 0 precision: 5)
		= (WCGeoHash hashFor: 0 @ 0 precision: 5) ].
	self assertEquivalent: [
		(WCGeoHash hashFor: 0 @ 0 precision: 5)
		= (WCGeoHash hashFor: 0 @ 0 precision: 4) ]
]
