Class {
	#name : #BaselineOfWCGeoHashWebApp,
	#superclass : #BaselineOf,
	#category : #BaselineOfWCGeoHashWebApp
}

{ #category : #baselines }
BaselineOfWCGeoHashWebApp >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Camping'
			with: [ spec repository: 'github://mattonem/WildCamping' ].
		spec
			baseline: 'PjHttpClient'
			with: [ spec repository: 'github://mattonem/RestClientApp:master' ].
		spec package: #WCGeoHash.
		spec package: #WCGeoHashWebApp with: [ spec requires: #(Camping PJHttpClient WCGeoHash) ] ]
]
