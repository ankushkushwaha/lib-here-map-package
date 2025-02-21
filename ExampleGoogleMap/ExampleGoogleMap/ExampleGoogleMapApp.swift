//
//  ExampleGoogleMapApp.swift
//  ExampleGoogleMap
//
//  Created by Ankush Kushwaha on 17/02/25.
//

import SwiftUI
import GoogleMaps
import GoogleMapTarget

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

