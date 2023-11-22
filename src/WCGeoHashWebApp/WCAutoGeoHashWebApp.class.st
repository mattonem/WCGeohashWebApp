Class {
	#name : #WCAutoGeoHashWebApp,
	#superclass : #PjFileBasedWebApp,
	#traits : 'StaticComponentHolder',
	#classTraits : 'StaticComponentHolder classTrait',
	#instVars : [
		'db'
	],
	#category : #WCGeoHashWebApp
}

{ #category : #accessing }
WCAutoGeoHashWebApp class >> appClasses [

	<pharoJsSkip>
	^ super appClasses , { WCCMap  }
]

{ #category : #accessing }
WCAutoGeoHashWebApp class >> bridgeClientClass [

	<pharoJsSkip>
	^ PjZnHostedBrowserBridgeClient
]

{ #category : #accessing }
WCAutoGeoHashWebApp class >> exporterClass [

	<pharoJsSkip>
	^ PjFileExporterWithIndexHtml
]

{ #category : #accessing }
WCAutoGeoHashWebApp class >> generateHtmlUsing: html [

	<pharoJsSkip>
	html div
		class: 'container';
		with: [
			html div
				class: 'card';
				with: [
					WCCMap for: self on: html named: #map.
					html div
						class: 'card-body';
						with: [
							html div
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										value: 0;
										id: 'lon'.
									html label
										for: 'lon';
										with: 'Longitude' ].
							html div
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										value: 0;
										id: 'lat'.
									html label
										for: 'lat';
										with: 'Latitude' ].
							html div
								class: 'mb-3';
								with: [
									html button
										class: 'btn btn-primary';
										id: 'goTo';
										with: 'Go to' ].
							html div
								class: 'form-check form-switch';
								with: [
									html checkbox
										class: 'form-check-input';
										checked;
										id: 'auto'.
									html label
										class: 'form-check-label';
										for: 'auto';
										with: 'Auto calculate' ].

							html div
								class: 'form-check form-switch';
								with: [
									html checkbox
										class: 'form-check-input';
										checked;
										id: 'debug'.
									html label
										class: 'form-check-label';
										for: 'debug';
										with: 'Debug view' ].
							html paragraph with: 'GeoHash address:'.
							html span id: 'result' ] ] ]
]

{ #category : #accessing }
WCAutoGeoHashWebApp class >> updateHtmlRoot: root [

	<pharoJsSkip>
	root language: 'en'.
	root stylesheet url:
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'.
	root stylesheet url:
		'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css'.
	root javascript url:
		'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js'
]

{ #category : #'initialize-release' }
WCAutoGeoHashWebApp >> calculate [

	| lon lat region regions adresses ghs |
	(document getElementById: 'auto') checked ifFalse: [ ^ self ].
	region := (self componentNamed: #map) getBounds.
	lon := (self componentNamed: #map) getCenter lng.
	lat := (self componentNamed: #map) getCenter lat.
	adresses := ''.
	region := (self componentNamed: #map) getBounds.
	regions := WCGeoHash divideRegion: region.
	ghs := WCGeoHash hashesCoverRegion: region precision: 9.
	(self componentNamed: #map) removeAllLayers.
	ghs do: [ :aGh |
		db getObjectsIn: aGh do: [ :add :object |
			| marker |
			marker := (self componentNamed: #map) addMarker: add center.
			marker bindPopup: object ].
		adresses := adresses , ' ' , aGh stringAddress ].
	(document getElementById: 'result') innerHTML: adresses.
	(document getElementById: 'debug') checked ifTrue: [
		self drawDebug: regions andGH: ghs ].
	(document getElementById: 'lon') value: lon.
	(document getElementById: 'lat') value: lat
]

{ #category : #'initialize-release' }
WCAutoGeoHashWebApp >> defaultCoordinates [

	^ 48.85071003048404 @ 2.3634338378906254
]

{ #category : #'initialize-release' }
WCAutoGeoHashWebApp >> drawDebug: regions andGH: ghs [ 

	regions do: [ :aRow |
		aRow do: [ :aRect |
			 ((self componentNamed: #map)
					 polygon: {
							 aRect topLeft.
							 aRect topRight.
							 aRect bottomRight.
							 aRect bottomLeft }
					 with: { (#color -> #green) } asDictionary) ] ].
	ghs do: [ :gh |
		 ((self componentNamed: #map) polygon: {
					 gh bounds topLeft.
					 gh bounds topRight.
					 gh bounds bottomRight.
					 gh bounds bottomLeft }) ]
]

{ #category : #'initialize-release' }
WCAutoGeoHashWebApp >> initialize [

	super initialize.
	self initializeComponentHolder
]

{ #category : #'initialize-release' }
WCAutoGeoHashWebApp >> start [

	
	db := WCGeoHashHttpRetriver new baseUrl:
		      (WCUrl new addToPath: 'WCGeohashWebApp/data').
	(document getElementById: 'goTo') addEventListener: #click block: [
		| lon lat |
		lon := (document getElementById: 'lon') value asNumber.
		lat := (document getElementById: 'lat') value asNumber.
		(self componentNamed: #map) setView: lat @ lon ].
	(self componentNamed: #map)
		on: #moveend
		do: [ :e | self calculate ].
	(self componentNamed: #map)
		on: #moveend
		do: [ :e |
			| lon lat offset |
			lon := e target getCenter lng.
			offset := 0.
			[ lon > 180 ] whileTrue: [
				offset := offset + 1.
				lon := lon - 360 ].
			[ lon < -180 ] whileTrue: [
				offset := offset - 1.
				lon := lon + 360 ].
			lat := e target getCenter lat.
			(document getElementById: 'lon') value: lon.
			(document getElementById: 'lat') value: lat ].
	(self componentNamed: #map) setView: self defaultCoordinates
]
