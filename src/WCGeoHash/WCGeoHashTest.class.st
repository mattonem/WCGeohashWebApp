"
A GeoHashTest is a test class for testing the behavior of GeoHash
"
Class {
	#name : #WCGeoHashTest,
	#superclass : #TestCase,
	#category : #'WCGeoHash-Tests'
}

{ #category : #test }
WCGeoHashTest >> testAdjacentToDirection [

	| gh |
	gh := WCGeoHash hashFor: 48.669 @ -4.329 precision: 5.
	self assert: gh north precision equals: gh precision.
	self assert: gh north stringAddress equals: 'gbsvj'
]

{ #category : #test }
WCGeoHashTest >> testAllNeighbours [

	| gh neighbours |
	gh := WCGeoHash fromString: 'r3gx2f77'.
	neighbours := gh allNeighbours collect: #stringAddress.
	self assert: neighbours size equals: 8.
	self assert: (neighbours includesAll:
			 { 'r3gx2f7k'. 'r3gx2f7s'. 'r3gx2f7e'. 'r3gx2f7d'. 'r3gx2f76'.
			 'r3gx2f74'. 'r3gx2f75'. 'r3gx2f7h' })
]

{ #category : #test }
WCGeoHashTest >> testArea [

	self assert: (WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7) area
		< (WCGeoHash hashFor: 9.9996 @ -4.329 precision: 6) area
]

{ #category : #test }
WCGeoHashTest >> testBounds [

	| gh |
	gh := WCGeoHash fromString: 's0000'.
	self
		assert: gh bounds
		closeTo:
		(Rectangle origin: 0 @ 0 corner: 0.0439453125 @ 0.0439453125).
	gh := WCGeoHash fromString: 's0001'.
	self
		assert: gh bounds
		closeTo:
		(Rectangle origin: 0 @ 0.0439453125 corner: 0.0439453125 @ 0.087890625)
]

{ #category : #test }
WCGeoHashTest >> testCenter [

	| gh |
	gh := WCGeoHash fromString: 's0000'.
	self assert: gh center closeTo: 0.0 @ 0.0 precision: 0.1
]

{ #category : #test }
WCGeoHashTest >> testEast [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: gh east precision equals: gh precision.
	self assert: gh east stringAddress equals: 'ecubvs2'.
	gh := WCGeoHash hashFor: 48.669 @ -4.329 precision: 5.
	self assert: gh east precision equals: gh precision.
	self assert: gh east stringAddress equals: 'gbsuy'
]

{ #category : #tests }
WCGeoHashTest >> testEncode [

	self assert: (WCGeoHash hashOf: (20@10) precision: 9) equals: 's5x1g8cu2' .
	self assert: (WCGeoHash hashOf: (48.669@(-4.329)) precision: 1) equals: 'g' .
	self assert: (WCGeoHash hashOf: (48.669@(-4.329)) precision: 5) equals: 'gbsuv'.
]

{ #category : #test }
WCGeoHashTest >> testEquals [

	| gh1 gh2 |
	gh1 := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	gh2 := WCGeoHash hashFor: 9.9996 @ -4.3294 precision: 7.
	self assert: gh1 equals: gh2.
	self assert: gh1 hash equals: gh1 hash .
]

{ #category : #test }
WCGeoHashTest >> testHashesCoverRegion [

	| region ghs expectedAddresses actualAddresses |
	region := Rectangle
		          origin: 48.833763586380556 @ 2.2523689270019536
		          corner: 48.86765074082236 @ 2.474498748779297.
	ghs := WCGeoHash hashesCoverRegion: region precision: 7.

	self assert: ghs size equals: 12.

	expectedAddresses := #( u09tv u09wj u09wn u09wh u09ty u09tu u09tz
	                        u09wp u09tg u09w5 u09y0 u09vb ) asSet.
	actualAddresses := ghs collect: #stringAddress as: Set.
	self assert: actualAddresses equals: expectedAddresses
]

{ #category : #tests }
WCGeoHashTest >> testInstance [

	| gh |
	gh := WCGeoHash fromByteArray: #[ 1 2 ].
	self assert: (gh byteAt: 1) equals: 1.
	self assert: (gh byteAt: 2) equals: 2.
	self assert: gh precision equals: 2.
	self assert: gh stringAddress equals: '12'.
	gh := WCGeoHash fromByteArray: #[ 1 31 ].
	self assert: gh stringAddress equals: '1z'.
	self should: [ WCGeoHash fromByteArray: #[ 1 32 ] ] raise: Exception.
	gh := WCGeoHash fromString: '12'.
	self assert: gh stringAddress equals: '12'.
	gh := WCGeoHash fromString: '1z'.
	self assert: gh stringAddress equals: '1z'.
	gh := WCGeoHash hashFor: (0@0) precision:  2.
	self assert: gh stringAddress equals: 's0'
]

{ #category : #test }
WCGeoHashTest >> testNorth [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: gh north precision equals: gh precision.
	self assert: gh north stringAddress equals: 'ecubvkx'.
	gh := WCGeoHash hashFor: 48.669 @ -4.329 precision: 5.
	self assert: gh north precision equals: gh precision.
	self assert: gh north stringAddress equals: 'gbsvj'
]

{ #category : #test }
WCGeoHashTest >> testSouth [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: gh south precision equals: gh precision.
	self assert: gh south stringAddress equals: 'ecubvkp'.
	gh := WCGeoHash hashFor: 48.669 @ -4.329 precision: 5.
	self assert: gh south precision equals: gh precision.
	self assert: gh south stringAddress equals: 'gbsut'
]

{ #category : #test }
WCGeoHashTest >> testWest [

	| gh |
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: gh west precision equals: gh precision.
	self assert: gh west stringAddress equals: 'ecubvkq'.
	gh := WCGeoHash hashFor: 48.669 @ -4.329 precision: 5.
	self assert: gh west precision equals: gh precision.
	self assert: gh west stringAddress equals: 'gbsuu'
]
