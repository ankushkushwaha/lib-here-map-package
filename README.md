# Map-library-package

![Alt Text](preview.gif)

The swift package allows developers to add different map SDKs and use common map features through a common interface from iOS app.


### Architecture

<img src="architecture.svg" alt="Description">


### Steps to use the library:
1. Initialize the map (Google map/ Here map) class by providing authentication keys / Token.
2. This Initialization will create a singleton of type MapController, Which is a common interface to call methods on map.
3. From the view part, use this singleton (MapController) to call methods on map for example: addMarkers(_) and drawRoute(_) etc.


### HereMap Integration

In you App entry point initialize HereMapWrapper, and pass it to the view. Also for better lifecycle handling call disposeHERESDK() when app gets terminated.

And ExampleApp might look like as follows:   

```
@main
struct ExampleApp: App {
    
    init() {
        observeAppLifecycle()
        
        initializeHERESDK()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(mapController: HereMapWrapper.shared!)
        }
    }
}

extension ExampleApp {
    private func initializeHERESDK() {
        HereMapWrapper.configure(accessKeyID: Constants.ACCESS_KEY_ID,
                                 accessKeySecret: Constants.ACCESS_KEY_SECRET)
    }
    
    private func disposeHERESDK() {
        // Free HERE SDK resources before the application shuts down.
        // Usually, this should be called only on application termination.
        
        // After this call, the HERE SDK is no longer usable unless it is initialized again.
        SDKNativeEngine.sharedInstance = nil
    }
    
    private func observeAppLifecycle() {
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification,
                                               object: nil,
                                               queue: nil) { _ in
            // Perform cleanup or final tasks here.
            print("App is about to terminate.")
            disposeHERESDK()
        }
    }
}
```

For more information on integration please check ExampleHereMap project, which is inlucded in the package.


### GoogleMap Integration

An example of initialize Google maps:

```
@main
struct ExampleGoogleMapApp: App {
    
    init() {
        GoogleMapWrapper.configure("AIzaSyDMugBPnM-3__t2tiBK-ODnHS7e6kzc8BI")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(mapController: GoogleMapWrapper.shared!)
        }
    }
}
```
