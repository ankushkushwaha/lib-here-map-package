//
//  SampleApp.swift
//  Sample
//
//  Created by Ankush Kushwaha on 19/01/25.
//

import SwiftUI
//
//  ExampleApp.swift
//  Example
//
//  Created by Ankush Kushwaha on 21/12/24.
//

import SwiftUI
import heresdk
import HereMapTarget

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
