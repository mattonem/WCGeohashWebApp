Class {
	#name : #WCGeoHash,
	#superclass : #Object,
	#instVars : [
		'byteArray'
	],
	#category : #WCGeoHash
}

{ #category : #'as yet unclassified' }
WCGeoHash class >> areaOfRect: aRect [
	^ aRect width * aRect height
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> characterList [
	^ '0123456789bcdefghjkmnpqrstuvwxyz'
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> divideRegion: aRect [

	| result |
	result := Array
		          with: (Array new: 3)
		          with: (Array new: 3)
		          with: (Array new: 3).
	0 to: 2 do: [ :i |
		0 to: 2 do: [ :j |
			(result at: i + 1) at: j + 1 put: (Rectangle
					 origin: aRect origin x + (i * aRect width / 3)
						 @ (aRect origin y + (j * aRect height / 3))
					 corner: aRect origin x + (i + 1 * aRect width / 3)
						 @ (aRect origin y + (j + 1 * aRect height / 3))) ] ].
	^ result
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> fromByteArray: aByteArray [

	^ self new
		  byteArray: aByteArray;
		  yourself
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> fromInteger: anInteger precision: aPrecision [

	^ self new
		  integer: anInteger;
		  precision: aPrecision;
		  yourself
]

{ #category : #'instance creation' }
WCGeoHash class >> fromString: aString [

	^ self new
		  byteArray: (aString asOrderedCollection collect: [ :aCharacter |
					   (self characterList indexOf: aCharacter) - 1 ]);
		  yourself
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> hashFor: coord coverRegion: aRectangle precision: anInteger [

	| gh |
	anInteger = 0 ifTrue: [ ^ self hashFor: coord precision: anInteger. ].
	gh := self hashFor: coord precision: anInteger.
	^ (gh coverRegion: aRectangle)
		  ifTrue: [ gh ]
		  ifFalse: [
			  ^ self
				    hashFor: coord
				    coverRegion: aRectangle
				    precision: anInteger - 1 ]
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> hashFor: coordinate precision: precision [

	| idx bit evenBit geohash lat lon lonMin lonMax latMin latMax currentPrecision |
	lat := coordinate x.
	lon := coordinate y.
	idx := 0.
	bit := 0.
	evenBit := true.
	currentPrecision := 0.
	geohash := ByteArray new: precision.
	lonMin := -180.
	lonMax := 180.
	latMin := -90.
	latMax := 90.
	[ currentPrecision < precision ] whileTrue: [
		evenBit
			ifTrue: [
				| lonMid |
				lonMid := lonMin + lonMax / 2.
				lon >= lonMid
					ifTrue: [
						idx := idx * 2 + 1.
						lonMin := lonMid ]
					ifFalse: [
						idx := idx * 2.
						lonMax := lonMid ] ]
			ifFalse: [
				| latMid |
				latMid := latMin + latMax / 2.
				lat >= latMid
					ifTrue: [
						idx := idx * 2 + 1.
						latMin := latMid ]
					ifFalse: [
						idx := idx * 2.
						latMax := latMid ] ].
		evenBit := evenBit not.
		bit := bit + 1.
		bit = 5 ifTrue: [
			currentPrecision := currentPrecision + 1.
			geohash at: currentPrecision put: idx.
			bit := 0.
			idx := 0 ] ].
	^ self fromByteArray: geohash
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> hashOf: coordinate precision: precision [

	^ (self hashFor: coordinate precision: precision) stringAddress
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> hashesFor: coord coverRegion: region precision: precision [

	| central result regions toBeAdded |
	regions := self divideRegion: region.
	central := self
		           hashFor: coord
		           coverRegion: ((regions at: 2) at: 2)
		           precision: precision.
	[ central area > (self areaOfRect: region) ] whileTrue: [
		central := self hashFor: coord precision: central precision + 1 ].
	(central precision = 0) ifTrue: [^ Set with: central].
	result := Set new.
	toBeAdded := Set with: central.
	[
	result addAll: toBeAdded.
	toBeAdded isEmpty ] whileFalse: [
		toBeAdded := Set new.
		result do: [ :gh |
			gh allNeighbours do: [ :aGh |
				(result includes: aGh) ifFalse: [
					(aGh intersects: region) ifTrue: [ toBeAdded add: aGh ] ] ] ] ].

	^ result
]

{ #category : #'as yet unclassified' }
WCGeoHash class >> northDirection [
	^ 0
]

{ #category : #'as yet unclassified' }
WCGeoHash >> = anOtherObject [

	^ self class = anOtherObject class and: [ byteArray = anOtherObject byteArray ]
]

{ #category : #'as yet unclassified' }
WCGeoHash >> adjacentWithBorder: borders andNeighbours: neighbours [

	| parent |
	parent := self parent.
	((borders at: self type) includes: byteArray last) ifTrue: [
		parent := parent
			          adjacentWithBorder: borders
			          andNeighbours: neighbours ].
	^ WCGeoHash fromByteArray: (parent byteArray copyWith:
			   ((neighbours at: self type) indexOf: byteArray last) - 1)
]

{ #category : #accessing }
WCGeoHash >> allNeighbours [

	| temp result |
	temp := self.
	result := OrderedCollection new.
	result add: (temp := temp north).
	result add: (temp := temp east).
	result add: (temp := temp south).
	result add: (temp := temp south).
	result add: (temp := temp west).
	result add: (temp := temp west).
	result add: (temp := temp north).
	result add: (temp := temp north).
	^ result
]

{ #category : #'as yet unclassified' }
WCGeoHash >> area [
	^ self bounds width * self bounds height
]

{ #category : #accessing }
WCGeoHash >> bounds [

	| evenBit latMin latMax lonMin lonMax |
	evenBit := true.
	latMin := -90.
	latMax := 90.
	lonMin := -180.
	lonMax := 180.
	byteArray do: [ :aByte |
		-4 to: 0 do: [ :i |
			| bitN |
			bitN := (aByte bitShift: i) bitAnd: 1.
			evenBit
				ifTrue: [
					| lonMid |
					lonMid := lonMin + lonMax / 2.
					bitN = 1
						ifTrue: [ lonMin := lonMid ]
						ifFalse: [ lonMax := lonMid ] ]
				ifFalse: [
					| latMid |
					latMid := latMin + latMax / 2.
					bitN = 1
						ifTrue: [ latMin := latMid ]
						ifFalse: [ latMax := latMid ] ].
			evenBit := evenBit not ] ].

	^ Rectangle origin: latMin @ lonMin corner: latMax @ lonMax
]

{ #category : #'as yet unclassified' }
WCGeoHash >> byteArayToString [

	^ String streamContents: [ :s |
		  s << '#['.
		  byteArray do: [ :el | el printOn: s ] separatedBy: [ s << ' ' ].
		  s << ']' ]
]

{ #category : #accessing }
WCGeoHash >> byteArray [
	^ byteArray
]

{ #category : #accessing }
WCGeoHash >> byteArray: aCollection [
		aCollection do: [ :aByte |
		aByte <= self maxByteValue ifFalse: [
			Error signal: 'Geohash bytes cannot be higher than 31' ] ].

	byteArray := aCollection
]

{ #category : #accessing }
WCGeoHash >> byteAt: anInteger [

	^ byteArray at: anInteger
]

{ #category : #'as yet unclassified' }
WCGeoHash >> center [
	
	^ self bounds topLeft + self bounds bottomRight / 2
]

{ #category : #'as yet unclassified' }
WCGeoHash >> characterFor: anInteger [ 
	^ (self class characterList at: anInteger + 1)
]

{ #category : #'as yet unclassified' }
WCGeoHash >> coverRegion: aRectangle [

	^ (self point: aRectangle origin greaterThan: self bounds origin) and: [ 
		(self point: aRectangle corner lesserThan: self bounds corner) ]
]

{ #category : #'as yet unclassified' }
WCGeoHash >> east [

	byteArray ifEmpty: [ ^ self ].
	^ self
		  adjacentWithBorder: self eastBorders
		  andNeighbours: self eastNeighbours
]

{ #category : #'as yet unclassified' }
WCGeoHash >> eastBorders [
	"	(WCGeoHash fromString: 'prxz')
		byteArayToString."

	^ {
		  #[10 11 14 15 26 27 30 31].
		  #[21 23 29 31] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> eastNeighbours [
	"	(WCGeoHash fromString: 'p0r21436x8zb9dcf5h7kjnmqesgutwvy')
		byteArayToString.
		"

	^ {
		  #[ 10 11 0 1 14 15 4 5 2 3 8 9 6 7 12 13 26 27 16 17 30 31 20 21
		     18 19 24 25 22 23 28 29 ].
		  #[ 21 0 23 2 1 4 3 6 29 8 31 10 9 12 11 14 5 16 7 18 17 20 19 22
		     13 24 15 26 25 28 27 30 ] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> hash [
	^ byteArray hash
]

{ #category : #'as yet unclassified' }
WCGeoHash >> height [
	^ self bounds height
]

{ #category : #'as yet unclassified' }
WCGeoHash >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."

	"Optimized; old code answered:
		(origin max: aRectangle origin) < (corner min: aRectangle corner)"

	| rOrigin rCorner |
	rOrigin := aRectangle origin.
	rCorner := aRectangle corner.
	rCorner x <= self bounds origin x ifTrue: [ ^ false ].
	rCorner y <= self bounds origin y ifTrue: [ ^ false ].
	rOrigin x >= self bounds corner x ifTrue: [ ^ false ].
	rOrigin y >= self bounds corner y ifTrue: [ ^ false ].
	^ true
]

{ #category : #accessing }
WCGeoHash >> maxByteValue [

	^ 31
]

{ #category : #'as yet unclassified' }
WCGeoHash >> north [

	byteArray ifEmpty: [ ^ self ].
	^ self
		  adjacentWithBorder: self northBorders
		  andNeighbours: self northNeighbours
]

{ #category : #'as yet unclassified' }
WCGeoHash >> northBorders [

	^ {
		  #[ 21 23 29 31 ].
		  #[ 10 11 14 15 26 27 30 31 ] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> northNeighbours [
	"	(WCGeoHash fromString: 'p0r21436x8zb9dcf5h7kjnmqesgutwvy')
		byteArayToString."

	^ {
		  #[ 21 0 23 2 1 4 3 6 29 8 31 10 9 12 11 14 5 16 7 18 17 20 19 22
		     13 24 15 26 25 28 27 30 ].
		  #[ 10 11 0 1 14 15 4 5 2 3 8 9 6 7 12 13 26 27 16 17 30 31 20 21
		     18 19 24 25 22 23 28 29 ] }
]

{ #category : #accessing }
WCGeoHash >> parent [
	^ self class fromByteArray: byteArray allButLast 
]

{ #category : #'as yet unclassified' }
WCGeoHash >> point: aPoint greaterThan: anotherPoint [
	^ aPoint x >= anotherPoint x and: [ aPoint y >= anotherPoint y ]
]

{ #category : #'as yet unclassified' }
WCGeoHash >> point: aPoint lesserThan: anotherPoint [

	^ aPoint x <= anotherPoint x and: [ aPoint y <= anotherPoint y ]
]

{ #category : #constants }
WCGeoHash >> precision [

	^ byteArray size
]

{ #category : #'as yet unclassified' }
WCGeoHash >> printOn: stream [

	<ingnoreForCoverage>
	super printOn: stream.
	stream nextPut: $(.
	self stringAddress printOn: stream.
	stream nextPut: $)
]

{ #category : #'as yet unclassified' }
WCGeoHash >> south [

	byteArray ifEmpty: [ ^ self ].
	^ self
		  adjacentWithBorder: self southBorders
		  andNeighbours: self southNeighbours
]

{ #category : #'as yet unclassified' }
WCGeoHash >> southBorders [

	^ {
		  #[ 0 2 8 10 ].
		  #[ 0 1 4 5 16 17 20 21 ] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> southNeighbours [

	^ {
		  #[ 1 4 3 6 5 16 7 18 9 12 11 14 13 24 15 26 17 20 19 22 21 0 23 2
		     25 28 27 30 29 8 31 10 ].
		  #[ 2 3 8 9 6 7 12 13 10 11 0 1 14 15 4 5 18 19 24 25 22 23 28 29
		     26 27 16 17 30 31 20 21 ] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> stringAddress [

	^ String new: self precision streamContents: [ :s |
		  byteArray do: [ :aByte | s nextPut: (self characterFor: aByte) ] ]
]

{ #category : #accessing }
WCGeoHash >> type [
 ^ (self precision \\ 2) + 1
]

{ #category : #'as yet unclassified' }
WCGeoHash >> west [

	byteArray ifEmpty: [ ^ self ].
	^ self
		  adjacentWithBorder: self westBorders
		  andNeighbours: self westNeighbours
]

{ #category : #'as yet unclassified' }
WCGeoHash >> westBorders [
	"	(WCGeoHash fromString: '028b')
		byteArayToString."

	^ {
		  #[ 0 1 4 5 16 17 20 21 ].
		  #[ 0 2 8 10 ] }
]

{ #category : #'as yet unclassified' }
WCGeoHash >> westNeighbours [
	"	(WCGeoHash fromString: '14365h7k9dcfesgujnmqp0r2twvyx8zb')
		byteArayToString."

	^ {
		  #[ 2 3 8 9 6 7 12 13 10 11 0 1 14 15 4 5 18 19 24 25 22 23 28 29
		     26 27 16 17 30 31 20 21 ].
		  #[ 1 4 3 6 5 16 7 18 9 12 11 14 13 24 15 26 17 20 19 22 21 0 23 2
		     25 28 27 30 29 8 31 10 ] }
]
