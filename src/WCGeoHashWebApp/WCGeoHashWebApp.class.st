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
	^ super appClasses , { WCCOSMapWidget  }
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
					WCCOSMapWidget for: self on: html named: #map.
					html div
						class: 'card-body';
						with: [
							html div
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										id: 'lon'.
									html label
										for: 'lon';
										with: 'Longitude'].
									html div
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										id: 'lat'.
									html label
										for: 'lat';
										with: 'Latitude'].
									html div
								class: 'form-floating';
								with: [
									html textInput
										class: 'form-control';
										id: 'precision'.
									html label
										for: 'precision';
										with: 'Precision'].
									html button
										id: 'calculate';
										with: 'calculate' ].
							html span id: 'result' ] ] 
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
WCGeoHashWebApp >> initialize [

	super initialize.
	self initializeComponentHolder
]

{ #category : #'initialize-release' }
WCGeoHashWebApp >> start [

	| layers |
	layers := OrderedCollection new.
	(document getElementById: 'calculate')
		addEventListener: #click
		block: [
			| lon lat gh precision |
			lon := (document getElementById: 'lon') value asNumber.
			lat := (document getElementById: 'lat') value asNumber.
			precision := (document getElementById: 'precision') value asNumber.
			gh := WCGeoHash hashFor: lon @ lat precision: precision.
			(document getElementById: 'result') innerHTML: gh stringAddress.
			layers do: [ :aLayer | aLayer remove ].
			layers removeAll.
			(self componentNamed: #map) fitBounds: gh bounds.
			gh allNeighbours do: [ :aGh |
				layers add: ((self componentNamed: #map)
						 polygon: {
								 aGh bounds topLeft.
								 aGh bounds topRight.
								 aGh bounds bottomRight.
								 aGh bounds bottomLeft }
						 with: { (#color -> #green) } asDictionary) ].
			layers add: ((self componentNamed: #map) polygon: {
						 gh bounds topLeft.
						 gh bounds topRight.
						 gh bounds bottomRight.
						 gh bounds bottomLeft }).
			layers add: ((self componentNamed: #map) addMarker: lon @ lat) ]
]
