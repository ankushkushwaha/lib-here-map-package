# Map-library-package

![Alt Text](preview.gif)

The swift package allows developers to add different map SDKs and use common map features through a common interface from iOS app.



<img src="archicture.svg" width="200" alt="Description">


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
