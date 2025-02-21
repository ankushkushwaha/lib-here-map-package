//
//  File.swift
//  here-map-package
//
//  Created by Ankush Kushwaha on 17/02/25.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import CommonMapInterface

public class MarkerActions: NSObject {
    
    private weak var mapView: GMSMapView?
    public var tapHandler: ((GMSMarker) -> Void)?
    
    private var clusterManager: GMUClusterManager?

    init(_ mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    public func addMarkers(_ markers: [MarkerWithData]) {
        for markerWithData in markers {
            let marker = GMSMarker(position: markerWithData.coordinates)
            
            marker.icon = markerWithData.image
            marker.map = mapView
            marker.userData = markerWithData.metaData
        }
        
        mapView?.delegate = self
    }
    
    public func addClusterMarkers(_ markers: [MarkerWithData],
                                  clusterImage: UIImage?) {
        guard let mapView = mapView else {
            return
        }
        self.clusterManager = GMUClusterManager(
            map: mapView,
            algorithm: GMUNonHierarchicalDistanceBasedAlgorithm(),
            renderer: GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: CustomClusterIconGenerator(customImage: clusterImage))
        )

        
        var arr: [GMSMarker] = []
        for markerWithData in markers {
            let marker = GMSMarker(position: markerWithData.coordinates)
            marker.icon = markerWithData.image
            marker.userData = markerWithData.metaData
            arr.append(marker)
        }
        
        clusterManager?.add(arr)
        clusterManager?.setMapDelegate(self)
    }
}

extension MarkerActions: GMSMapViewDelegate, GMUClusterManagerDelegate {
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        tapHandler?(marker)
        
        // center the map on tapped marker
        mapView.animate(toLocation: marker.position)
        
        return false
    }
}

class CustomClusterIconGenerator: GMUDefaultClusterIconGenerator {
    private let customImage: UIImage?

    init(customImage: UIImage?) {
        self.customImage = customImage
        super.init()
    }

    override func icon(forSize size: UInt) -> UIImage {
        return customImage ?? super.icon(forSize: size)
    }
}
