//
//  HereMapWrapper.swift
//  MyPackage
//
//  Created by Ankush Kushwaha on 20/12/24.
//

import Foundation
import heresdk
import UIKit
import CoreLocation
import CommonMapInterface
import SwiftUI

public class HereMapWrapper: @preconcurrency MapController {
    public var tapHandler: ((Any) -> Void)? {
        didSet {
            tapDelegate?.tapHandler = tapHandler
        }
    }

    public static var shared: (any MapController)? = nil 

    public var mapView: MapView?
    private var mapViewRepresentable: MapRepresentable
    private var markerActions: MarkerActions?
    private var cameraAction: CameraAction?
    private var routingAction: RoutingActions?
    private var tapDelegate: TapHandler?

//    public var markerTapped: ((MapMarker) -> Void)? {
//        didSet {
//            tapDelegate?.tapHandler = markerTapped
//        }
//    }
//    public var clusterTapped: ((MapMarkerCluster.Grouping) -> Void)? {
//        didSet {
//            tapHandler?.clusterTapped = clusterTapped
//        }
//    }
        

    
    public func mapUIRepresentable() -> AnyView {
            return AnyView(mapViewRepresentable)  // ✅ Wrap it inside AnyView
        }
    
    @MainActor public func clearMap() {
        routingAction?.clearRoute()
        markerActions?.clearMarkers()
    }
        
    @MainActor public func moveCamera(_ point: CLLocationCoordinate2D,
                                      zoomLevel: Float? = 12.0) {
        cameraAction?.moveCamera(point.geoCordinates,
                                zoom: zoomLevel ?? 12.0)
    }
    
    @MainActor public func addMarkers(_ markers: [MarkerWithData]) {
        markerActions?.addMarkers(markers)
    }

    @MainActor public func addMarkerCluster(_ markers: [MarkerWithData],
                                            clusterImage: UIImage) {
        
        var markerList: [MapMarker] = []
        
        for point in markers {
            let marker = createMapMarker(point.coordinates.geoCordinates,
                                         point.metaData,
                                         image: point.image)
            markerList.append(marker)
        }
        
        markerActions?.addMapMarkerCluster(markerList,
                                          clusterImage: clusterImage)
    }
        
    @MainActor public func darwRoute(start: GeoCoordinates,
                                     end: GeoCoordinates, routeColor: UIColor = .red, widthInPixels: CGFloat = 20.0) {
        routingAction?.darwRoute(
            start: start,
            end: end,
            routeColor : routeColor,
            widthInPixels: widthInPixels
        )
    }
    
    
    @MainActor public func drawRoute(_ points: [CLLocationCoordinate2D],
                          width: CGFloat?,
                          color: UIColor?) {
        
        routingAction?.drawRouteFromPoints(
            points: points.map {$0.geoCordinates},
            width: width ?? 20.0,
            color: color ?? UIColor(red: 0, green: 0.56, blue: 0.54, alpha: 0.63)
        )
    }

    
    @MainActor
    public init(accessKeyID: String,
                accessKeySecret: String) {
        
        let authenticationMode = AuthenticationMode.withKeySecret(
            accessKeyId: accessKeyID,
            accessKeySecret: accessKeySecret
        )
        let options = SDKOptions(
            authenticationMode: authenticationMode
        )
        do {
            try SDKNativeEngine.makeSharedInstance(options: options)
        } catch let engineInstantiationError {
            fatalError("Failed to initialize the HERE SDK. Cause: \(engineInstantiationError)")
        }
        
        self.mapViewRepresentable = MapRepresentable()
        
        mapViewRepresentable.mapCreated = { [weak self] mapView in
            self?.mapView = mapView
            
            self?.cameraAction = CameraAction(mapView)
            self?.markerActions = MarkerActions(mapView)
            self?.routingAction = RoutingActions(mapView)

            self?.tapDelegate = TapHandler(mapView)

            // Load the map scene using a map scheme to render the map with.
            mapView.mapScene.loadScene(mapScheme: MapScheme.normalDay, completion: self?.onLoadScene)
        }
    }
    
    @MainActor public static func configure(accessKeyID: String, accessKeySecret: String) {
           guard shared == nil else {
               fatalError("HereMapWrapper is already configured.")
           }
           shared = HereMapWrapper(accessKeyID: accessKeyID, accessKeySecret: accessKeySecret)
    }
    
    @MainActor private func onLoadScene(mapError: MapError?) {
        guard mapError == nil else {
            print("Error: Map scene not loaded, \(String(describing: mapError))")
            return
        }
        
        // Optionally, enable low speed zone map layer.
        mapView?.mapScene.enableFeatures([MapFeatures.lowSpeedZones : MapFeatureModes.lowSpeedZonesAll]);
    }
    
    private func createMapMarker(_ geoCoordinates: GeoCoordinates,
                                 _ metaDataDict: [String: String],
                                 image: UIImage) -> MapMarker {
        guard let imageData = image.pngData() else {
            fatalError("Error: Image not found.")
        }
        
        let mapImage = MapImage(pixelData: imageData,
                                imageFormat: ImageFormat.png)
        let mapMarker = MapMarker(at: geoCoordinates, image: mapImage)
                
        mapMarker.setMetaData(metaDataDict: metaDataDict)
        
        return mapMarker
    }
}

extension GeoCoordinates: @unchecked @retroactive Sendable {}

