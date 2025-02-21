//
//  CameraAction.swift
//  here-map-package
//
//  Created by Ankush Kushwaha on 14/01/25.
//

import Foundation
import heresdk

class CameraAction {
    
    private let mapView: MapView
    
    init(_ mapView: MapView) {
        self.mapView = mapView
    }
    
    @MainActor func moveCamera(_ point: GeoCoordinates, zoom: Float) {
        let camera = mapView.camera
        let zoomLevel = MapMeasure(kind: .zoomLevel, value: Double(zoom))
        camera.lookAt(point: point, zoom: zoomLevel)
    }
    
}
