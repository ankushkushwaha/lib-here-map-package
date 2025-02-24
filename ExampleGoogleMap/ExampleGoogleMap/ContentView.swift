//
//  ContentView.swift
//  ExampleGoogleMap
//
//  Created by Ankush Kushwaha on 17/02/25.
//

import SwiftUI
import CoreLocation
import CommonMapInterface
import GoogleMaps
import GoogleMapsUtilsObjC

struct ContentView: View {
    @State var popupText: String? = nil
    var mapController: MapController
    
    private let metaDataKey =  "markerMetadataKey"
    
    var body: some View {
        VStack {
            Button("Add Marker") {

                let points = [
                    CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050), // Berlin Center
                    CLLocationCoordinate2D(latitude: 52.5300, longitude: 13.4200), // Top Right
                    CLLocationCoordinate2D(latitude: 52.5100, longitude: 13.3900)  // Bottom Left
                ]
                
                let markersWithData = points.map { coordinates in
                    MarkerWithData(
                        coordinates: coordinates,
                        metaData: [metaDataKey: "Marker metadata for cluster: \(coordinates.latitude), \(coordinates.longitude)"],
                        image: UIImage(systemName: "car.fill")!
                    )
                }
                
                mapController.addMarkers(markersWithData)
                
                mapController.moveCamera(points.first!, zoomLevel: 12.0)
            }
            
            Button("Add Clusters") {
                
                let points = [
                    CLLocationCoordinate2D(latitude: 52.53032, longitude: 13.37409),
                    CLLocationCoordinate2D(latitude: 52.5309, longitude: 13.3946),
                    CLLocationCoordinate2D(latitude: 52.53894, longitude: 13.39194),
                    CLLocationCoordinate2D(latitude: 52.54014, longitude: 13.37958),
                    CLLocationCoordinate2D(latitude: 52.53150, longitude: 13.38050),
                    CLLocationCoordinate2D(latitude: 52.53500, longitude: 13.38200),
                    CLLocationCoordinate2D(latitude: 52.53275, longitude: 13.38800),
                    CLLocationCoordinate2D(latitude: 52.53720, longitude: 13.37550),
                    CLLocationCoordinate2D(latitude: 52.53460, longitude: 13.39220),
                    CLLocationCoordinate2D(latitude: 52.53380, longitude: 13.37840)
                ]
                
                let markersWithData = points.map { coordinates in
                    MarkerWithData(
                        coordinates: coordinates,
                        metaData: [metaDataKey: "Marker metadata for cluster: \(coordinates.latitude), \(coordinates.longitude)"],
                        image: UIImage(systemName: "car.fill")!
                    )
                }

                let image = UIImage(named: "car")
                
                mapController.addMarkerCluster(
                    markersWithData,
                    clusterImage: image!
                )
                
                mapController.moveCamera(points.first!, zoomLevel: 13.0)
            }
            
            
            Button("Add Route") {
                
                let points: [CLLocationCoordinate2D] = [
                    CLLocationCoordinate2D(latitude: 52.5505, longitude: 13.3704), // Gesundbrunnen (North)
                    CLLocationCoordinate2D(latitude: 52.5426, longitude: 13.3499), // Mauerpark
                    CLLocationCoordinate2D(latitude: 52.5294, longitude: 13.4134), // Hackescher Markt
                    CLLocationCoordinate2D(latitude: 52.5208, longitude: 13.4094), // Alexanderplatz
                    CLLocationCoordinate2D(latitude: 52.5186, longitude: 13.3762), // Reichstag Building
                    CLLocationCoordinate2D(latitude: 52.5163, longitude: 13.3777), // Brandenburg Gate
                    CLLocationCoordinate2D(latitude: 52.5076, longitude: 13.3904), // Checkpoint Charlie
                    CLLocationCoordinate2D(latitude: 52.5037, longitude: 13.3769), // Potsdamer Platz
                    CLLocationCoordinate2D(latitude: 52.5097, longitude: 13.3758), // Tiergarten (Moved closer)
                    CLLocationCoordinate2D(latitude: 52.4958, longitude: 13.3051), // Charlottenburg Palace (West)
                    CLLocationCoordinate2D(latitude: 52.4701, longitude: 13.3872), // Schöneberg
                    CLLocationCoordinate2D(latitude: 52.4731, longitude: 13.4220), // Tempelhofer Feld
                    CLLocationCoordinate2D(latitude: 52.4854, longitude: 13.4443), // Treptower Park (Moved to end)
                    CLLocationCoordinate2D(latitude: 52.4617, longitude: 13.3722), // Rathaus Steglitz
                    CLLocationCoordinate2D(latitude: 52.4550, longitude: 13.2901)  // Wannsee (Furthest South-West)
                ]

                mapController.drawRoute(points, width: 5.0, color: .blue)
                
                mapController.moveCamera(points.first!, zoomLevel: 12.0)
            }
            
            Button("Clear map") {
                mapController.clearMap()
            }
            
            ZStack {
                mapController.mapUIRepresentable()
                
                if let popupText = popupText, !popupText.isEmpty  {
                    CustomPopupView(text: $popupText)
                }
            }

        }
        .padding()
        .onAppear {
            
            mapController.clusterTapped = { marker in
                
                if let marker = marker as? GMSMarker,
                   let cluster = marker.userData as? GMUCluster {
                    popupText = "Cluster contains \(cluster.count) markers"
                    
                    for marker in cluster.items {
                        popupText! += "\n \(marker.position)"
                    }
                }
            }
            
            mapController.markerTapped = { marker in
                if let marker = marker as? GMSMarker {
                    popupText = "Marker tapped at position \(marker.position)"
                    
                    if let metadata = marker.userData as? [String: Any] {
                        popupText = popupText! + "\n\n--------\n \(String(describing: metadata[metaDataKey]))"
                    }
                }
            }
        }
    }
}
