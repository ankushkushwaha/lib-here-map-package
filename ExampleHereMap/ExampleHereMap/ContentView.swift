//
//  ContentView.swift
//  HereMapPocSample
//
//  Created by Ankush Kushwaha on 21/12/24.
//

import SwiftUI
import CommonMapInterface
import CoreLocation
import heresdk

struct ContentView: View {
    @State private var popupText: String?
    let mapController: MapController
    
    let metaDataKey = "metadataKey"
    
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
            
            Button("Add Route via point") {
                
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
            
            Button("Add cluster") {
                
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
                
                mapController.addMarkerCluster(
                    markersWithData,
                    clusterImage: UIImage(systemName: "circle.fill")!
                )
                
                mapController.moveCamera(points.first!, zoomLevel: 12.0)
            }
            
            Button("Clear Map") {
                mapController.clearMap()
            }
            
            ZStack {
                mapController.mapUIRepresentable()
                
                if popupText != nil {
                    CustomPopupView(text: $popupText)
                }
            }
        }
        .padding()
        .onAppear {
            mapController.markerTapped = { tappedObject in
                if let marker = tappedObject as? MapMarker { // tapped on marker
                    
                    let data = marker.metadata?.getString(key: metaDataKey) ?? ""
                    popupText = "Marker Tapped \n Metadata: \(String(describing: data))"
                    
                }
            }
            
            mapController.clusterTapped = { tappedObject in
                if let markerGrouping = tappedObject as? MapMarkerCluster.Grouping {  // Tapped on cluster
                    
                    let metaDataForAllSelectedMarkers = markerGrouping.markers.map {
                        ($0.metadata?.getString(key: metaDataKey))!
                    }.joined(separator: "\n\n")
                    
                    popupText = """
                    Total markers in this tapped cluster marker: \(markerGrouping.markers.count)
                    
                    Total markers in this MapMarkerCluster: \(markerGrouping.parent.markers.count)
                    
                    ------------------
                    
                    \(metaDataForAllSelectedMarkers)
                    
                    """
                }
            }
        }
    }
}

