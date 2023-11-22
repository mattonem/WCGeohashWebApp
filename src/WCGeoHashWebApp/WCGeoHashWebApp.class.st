Class {
	#name : #WCGeoHashWebApp,
	#superclass : #PjFileBasedWebApp,
	#traits : 'StaticComponentHolder',
	#classTraits : 'StaticComponentHolder classTrait',
	#category : #WCGeoHashWebApp
}

{ #category : #accessing }
WCGeoHashWebApp class >> appClasses [

	<pharoJsSkip>
	^ super appClasses , { WCCMap  }
]

{ #category : #accessing }
WCGeoHashWebApp class >> bridgeClientClass [

	<pharoJsSkip>
	^ PjZnHostedBrowserBridgeClient
]

{ #category : #accessing }
WCGeoHashWebApp class >> exporterClass [

	<pharoJsSkip>
	^ PjFileExporterWithIndexHtml
]

{ #category : #accessing }
WCGeoHashWebApp class >> generateHtmlUsing: html [

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
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										value: 5;
										id: 'precision'.
									html label
										for: 'precision';
										with: 'Precision' ].
							html div
								class: 'mb-3';
								with: [
									html button
										class: 'btn btn-primary';
										id: 'calculate';
										with: 'calculate' ].
							html paragraph with: 'GeoHash address:'.
							html span id: 'result' ] ] ]
]

{ #category : #accessing }
WCGeoHashWebApp class >> updateHtmlRoot: root [

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
WCGeoHashWebApp >> defaultCoordinates [

	^ 48.85071003048404 @ 2.3634338378906254
]

{ #category : #'initialize-release' }
WCGeoHashWebApp >> initialize [

	super initialize.
	self initializeComponentHolder
]

{ #category : #'initialize-release' }
WCGeoHashWebApp >> start [

	|  gh |
	gh := WCGeoHash hashFor: 0 @ 0 precision: 5.

	(self componentNamed: #map)
		on: #moveend
		do: [ :e |
			| lon lat precision offset bounds |
			lon := e target getCenter lng.
			offset := 0.
			[ lon > 180 ] whileTrue: [
				offset := offset + 1.
				lon := lon - 360 ].
			[ lon < -180 ] whileTrue: [
				offset := offset - 1.
				lon := lon + 360 ].
			lat := e target getCenter lat.
			precision := (document getElementById: 'precision') value asNumber.
			gh := WCGeoHash hashFor: lat @ lon precision: precision.
			(document getElementById: 'result') innerHTML: gh stringAddress.
			
			(self componentNamed: #map) removeAllLayers .
			gh allNeighbours do: [ :aGh |
				| b |
				b := aGh bounds translateBy: 0 @ (360 * offset).
				 ((self componentNamed: #map)
						 polygon: {
								 b topLeft.
								 b topRight.
								 b bottomRight.
								 b bottomLeft }
						 with: { (#color -> #green) } asDictionary) ].

			bounds := gh bounds translateBy: 0 @ (360 * offset).
			 ((self componentNamed: #map) polygon: {
						 bounds topLeft.
						 bounds topRight.
						 bounds bottomRight.
						 bounds bottomLeft }).
			((self componentNamed: #map) addMarker:
					 (gh center translateBy: 0 @ (360 * offset))).
			(document getElementById: 'lon') value: lon.
			(document getElementById: 'lat') value: lat ].
	(self componentNamed: #map) setView: self defaultCoordinates.
	(document getElementById: 'calculate')
		addEventListener: #click
		block: [
			| lon lat |
			lon := (document getElementById: 'lon') value asNumber.
			lat := (document getElementById: 'lat') value asNumber.
			(self componentNamed: #map) setView: lat @ lon ]
]
