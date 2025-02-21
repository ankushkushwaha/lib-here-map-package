//
//  File.swift
//  here-map-package
//
//  Created by Ankush Kushwaha on 14/01/25.
//

import Foundation
import heresdk
import UIKit

@MainActor
public class RoutingActions {
    private var mapView: MapView
    private var routingEngine: RoutingEngine
    private var waypoints: Array<Waypoint> = Array()
    private var disableOptimization = true
    
    private var widthInPixels = 20.0
    private var polylineColor = UIColor(red: 0, green: 0.56, blue: 0.54, alpha: 0.63)
    
    private var mapPolylineList = [MapPolyline]()

    
    public init(_ mapView: MapView) {
        self.mapView = mapView
        
        do {
            try routingEngine = RoutingEngine()
        } catch let engineInstantiationError {
            fatalError("Failed to initialize routing engine. Cause: \(engineInstantiationError)")
        }
        
        // Load the map scene using a map scheme to render the map with.
        mapView.mapScene.loadScene(mapScheme: MapScheme.normalDay, completion: onLoadScene)
    }
    
    private func onLoadScene(mapError: MapError?) {
        guard mapError == nil else {
            print("Error: Map scene not loaded, \(String(describing: mapError))")
            return
        }
        
        // Optionally, enable low speed zone map layer.
        mapView.mapScene.enableFeatures([MapFeatures.lowSpeedZones : MapFeatureModes.lowSpeedZonesAll]);
    }

    public func darwRoute(start: GeoCoordinates, end: GeoCoordinates,
        routeColor: UIColor = UIColor(red: 0, green: 0.56, blue: 0.54, alpha: 0.63),
        widthInPixels: CGFloat = 20.0
    ) {
        self.polylineColor = routeColor
        self.widthInPixels = widthInPixels
        
        // Hardcoded points for testing and Demo
        /*
        startGeoCoordinates = GeoCoordinates(latitude: 52.51087113766646, longitude: 13.396939881800781)
        destinationGeoCoordinates = GeoCoordinates(latitude: 52.53595152570505, longitude: 13.425996387349484)
         */
        
        waypoints = [Waypoint(coordinates: start),
                     Waypoint(coordinates: end)]
        calculateRoute(waypoints: waypoints)
    }
    
    private func calculateRoute(waypoints: Array<Waypoint>){
        routingEngine.calculateRoute(with: waypoints,
                                     carOptions: getCaroptions()) { (routingError, routes) in
            if routingError != nil {
                return
            }
            
            let route = routes!.first
            self.showRouteOnMap(route: route!)
        }
    }    
    
    private func getCaroptions() -> CarOptions {
        var carOptions = CarOptions()
        carOptions.routeOptions.enableTolls = true
        // Disabled - Traffic optimization is completely disabled, including long-term road closures. It helps in producing stable routes.
        // Time dependent - Traffic optimization is enabled, the shape of the route will be adjusted according to the traffic situation which depends on departure time and arrival time.
        carOptions.routeOptions.trafficOptimizationMode = disableOptimization ? TrafficOptimizationMode.disabled : TrafficOptimizationMode.timeDependent
        return carOptions
    }
    
    private func showRouteOnMap(route: Route) {
        
        let routeGeoPolyline = route.geometry
        
        do {
            let routeMapPolyline =  try MapPolyline(geometry: routeGeoPolyline,
                                                    representation: MapPolyline.SolidRepresentation(
                                                        lineWidth: MapMeasureDependentRenderSize(
                                                            sizeUnit: RenderSize.Unit.pixels,
                                                            size: widthInPixels),
                                                        color: polylineColor,
                                                        capShape: LineCap.round))
            
            mapView.mapScene.addMapPolyline(routeMapPolyline)
            mapPolylineList.append(routeMapPolyline)
                    

            
        } catch let error {
            fatalError("Failed to render MapPolyline. Cause: \(error)")
        }
    }
    
    public func clearRoute() {
        for mapPolyline in mapPolylineList {
            mapView.mapScene.removeMapPolyline(mapPolyline)
        }
        mapPolylineList.removeAll()
    }
    
    public func drawRouteFromPoints(points: [GeoCoordinates],
                                    width: CGFloat, color: UIColor) {
        if let mapPolyline = createMapPolyline(points,
                                width: width, color: color) {
            mapView.mapScene.addMapPolyline(mapPolyline)
        }
    }
    
    private func createMapPolyline(_ coordinates: [GeoCoordinates],
                                   width: CGFloat,
                                   color: UIColor) -> MapPolyline? {

        // We are sure that the number of vertices is greater than two, so it will not crash.
        let geoPolyline = try! GeoPolyline(vertices: coordinates)
        let lineColor = color
        let mapPolyline: MapPolyline? = nil
        let widthInPixels = width
        do {
            let mapPolyline =  try MapPolyline(geometry: geoPolyline,
                                                representation: MapPolyline.SolidRepresentation(
                                                lineWidth: MapMeasureDependentRenderSize(
                                                    sizeUnit: RenderSize.Unit.pixels,
                                                    size: widthInPixels),
                                                color: lineColor,
                                                capShape: LineCap.round))

            mapView.mapScene.addMapPolyline(mapPolyline)
            mapPolylineList.append(mapPolyline)
        } catch let error {
            fatalError("Failed to render MapPolyline. Cause: \(error)")
        }

        return mapPolyline
    }
}
