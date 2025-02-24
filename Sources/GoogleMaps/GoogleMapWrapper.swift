//
//  File.swift
//  lib-here-map-package
//
//  Created by Ankush Kushwaha on 17/02/25.
//

import Foundation
import GoogleMaps
import CommonMapInterface
import SwiftUI

public class GoogleMapWrapper: MapController {
    
    public var markerTapped: ((Any) -> Void)? {
        didSet {
            self.markerAction?.markerTapped = markerTapped
        }
    }
    
    public var clusterTapped: ((Any) -> Void)? {
        didSet {
            self.markerAction?.clusterTapped = clusterTapped
        }
    }

    public var mapView: GMSMapView?
    public var mapViewRepresentable: MapRepresentable
    
    private var cameraAction: CameraAction?
    private var markerAction: MarkerActions?
    private var routingAction: RoutingActions?
    
    public static var shared: (any MapController)?

    public static func configure(_ accessKeyID: String) {
        guard shared == nil else {
            fatalError("HereMapWrapper is already configured.")
        }
        shared = GoogleMapWrapper(accessKeyID)
    }
    
    init(_ accessKey: String) {
        
        GMSServices.provideAPIKey(accessKey)
        
        self.mapViewRepresentable = MapRepresentable()
        
        mapViewRepresentable.mapCreated = { [weak self] mapView in
            self?.mapView = mapView
            
            self?.cameraAction = CameraAction(mapView)
            self?.markerAction = MarkerActions(mapView)
            self?.routingAction = RoutingActions(mapView)
        }
    }
    
    public func mapUIRepresentable() -> AnyView {
        return AnyView(mapViewRepresentable)
    }
    
    public func mapUIRepresentable() -> any UIViewRepresentable {
        mapViewRepresentable
    }
    public func addMarkers(_ markers: [MarkerWithData]) {
        markerAction?.addMarkers(markers)
    }
    
    public func addMarkerCluster(_ markers: [MarkerWithData],
                                 clusterImage: UIImage) {
        markerAction?.addClusterMarkers(markers,
                                        clusterImage: clusterImage)
    }
    
    public func moveCamera(_ point: CLLocationCoordinate2D,
                           zoomLevel: Float? =  12.0) {
        cameraAction?.moveCamera(to: point,
                                 zoomLevel: zoomLevel ?? 12.0)
    }
    
    public func drawRoute(_ points: [CLLocationCoordinate2D],
                          width: CGFloat? = 5.0, color: UIColor? = .blue) {
        routingAction?.addRoute(points: points, width: width, color: color)
    }
    
    public func clearMap() {
        mapView?.clear()
    }
}



