Class {
	#name : #WCGeoHashHttpRetriverJsTest,
	#superclass : #PjWebAppTestCase,
	#traits : 'PjTAppRunsInJS + WCGeoHashHttpRetriverTestTrait',
	#classTraits : 'PjTAppRunsInJS classTrait + WCGeoHashHttpRetriverTestTrait classTrait',
	#category : #'WCGeoHashWebApp-Tests'
}

{ #category : #'suite parameters' }
WCGeoHashHttpRetriverJsTest class >> appClass [
 
	^ WCHelloWorldApp
]

{ #category : #accessing }
WCGeoHashHttpRetriverJsTest >> setUp [

	| folder host port scheme |
	super setUp.
	folder := FileLocator workingDirectory / 'dbTest2'.
	folder ensureDeleteAll.
	folder ensureCreateDirectory.
	db := WCGeoHashDB new rootFolder: folder.
	gh := WCGeoHash hashFor: 9.9996 @ -4.329 precision: 7.
	self assert: (db getIndexAt: gh) size equals: 0.
	id := '123'.

	db write: 'Random stuff' id: id geoHash: gh.
	retriever := self evalBlock: [ WCGeoHashHttpRetriver new ].
	server := self bridge server.
	server delegate map: 'data' to: (ZnPrefixMappingDelegate new
			 map: 'data'
			 to: (ZnStaticFileServerDelegate new
					  directory: folder;
					  yourself)).
	host := server url host.
	port := server url port.
	scheme := server url scheme.
	url := self evalBlock: [
		       WCUrl new
			       scheme: scheme;
			       host: host;
			       addToPath: 'data';
			       port: port ].
	ghIndex := self evalBlock: [  (WCGeoHash fromString: 'e')].
	
]

{ #category : #accessing }
WCGeoHashHttpRetriverJsTest >> tearDown [

	super tearDown.
]
