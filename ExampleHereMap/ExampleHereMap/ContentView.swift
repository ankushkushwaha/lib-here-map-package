//
//  ContentView.swift
//  HereMapPocSample
//
//  Created by Ankush Kushwaha on 21/12/24.
//

import SwiftUI
import HereMapTarget
import heresdk

struct ContentView: View {
    @State private var mapView = HereMapWrapper.shared!.mapView
    @State private var popupText: String?
    
    let markerMetadataKey = "metadata"
    
    var body: some View {
        VStack {
            
            Button("Add Marker") {
                HereMapWrapper.shared?.addMarker(
                    GeoCoordinates(
                        latitude: 52.520798,
                        longitude: 13.409408
                    ),
                    image: UIImage(systemName: "car.fill")!,
                    metaDataDict: [markerMetadataKey: "This is meta data"]
                )
                HereMapWrapper.shared?.moveCamera(GeoCoordinates(
                    latitude: 52.520798,
                    longitude: 13.409408
                ))
            }
            
            Button("Add Route") {
                let startGeoCoordinates = GeoCoordinates(latitude: 52.51087113766646, longitude: 13.396939881800781)
                let destinationGeoCoordinates = GeoCoordinates(latitude: 52.53595152570505, longitude: 13.425996387349484)
                HereMapWrapper.shared?.darwRoute(start: startGeoCoordinates, end: destinationGeoCoordinates)
                    
                HereMapWrapper.shared?.moveCamera(startGeoCoordinates)
            }
            
            Button("Add Route via point") {
            
                let points = [
                    GeoCoordinates(latitude: 52.53032, longitude: 13.37409),
                              GeoCoordinates(latitude: 52.5309, longitude: 13.3946),
                              GeoCoordinates(latitude: 52.53894, longitude: 13.39194),
                              GeoCoordinates(latitude: 52.54014, longitude: 13.37958)
                ]
                HereMapWrapper.shared?.drawRoute(points)
                    
                HereMapWrapper.shared?.moveCamera(points.first!)
            }
            
            Button("Add cluster") {
                
                let points = [
                    GeoCoordinates(latitude: 52.53032, longitude: 13.37409),
                    GeoCoordinates(latitude: 52.5309, longitude: 13.3946),
                    GeoCoordinates(latitude: 52.53894, longitude: 13.39194),
                    GeoCoordinates(latitude: 52.54014, longitude: 13.37958),
                    GeoCoordinates(latitude: 52.53150, longitude: 13.38050),
                    GeoCoordinates(latitude: 52.53500, longitude: 13.38200),
                    GeoCoordinates(latitude: 52.53275, longitude: 13.38800),
                    GeoCoordinates(latitude: 52.53720, longitude: 13.37550),
                    GeoCoordinates(latitude: 52.53460, longitude: 13.39220),
                    GeoCoordinates(latitude: 52.53380, longitude: 13.37840)
                ]
                
                let markersWithData = points.map { geoCoordinates in
                    MarkerWithData(
                        geoCoordinates: geoCoordinates,
                        metaData: [markerMetadataKey: "Marker metadata for cluster: \(geoCoordinates.latitude), \(geoCoordinates.longitude)"],
                        image: UIImage(systemName: "car.fill")!
                    )
                }

                HereMapWrapper.shared?.addMarkerCluster(
                    markersWithData,
                    clusterImage: UIImage(systemName: "circle.fill")!
                )

                HereMapWrapper.shared?.moveCamera(points.first!)
            }
            
            Button("Clear Map") {
                HereMapWrapper.shared?.clearMap()
            }
            
            ZStack {
                MapViewUIRepresentable(mapView: $mapView)
                    .edgesIgnoringSafeArea(.all)
                
                if let popupText = popupText {
                    CustomPopupView(text: $popupText)
                }
            }
        }
        .padding()
        .onAppear {
            HereMapWrapper.shared?.markerTapped = { marker in
                
                let data = marker.metadata?.getString(key: markerMetadataKey) ?? ""
                popupText = "Marker Tapped \n Metadata: \(String(describing: data))"
            }
            
            HereMapWrapper.shared?.clusterTapped = { markerGrouping in
                let metaDataForAllSelectedMarkers = markerGrouping.markers.map {
                    ($0.metadata?.getString(key: markerMetadataKey))!
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

#Preview {
    ContentView()
}
