//
//  File.swift
//  here-map-package
//
//  Created by Ankush Kushwaha on 18/02/25.
//

import Foundation
import GoogleMaps

public struct RoutingActions {
    private weak var mapView: GMSMapView?
    
    public init(_ mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    func addRoute(points: [CLLocationCoordinate2D],
                  width: CGFloat? = 5.0,
                  color: UIColor? = UIColor(red: 0, green: 0.56, blue: 0.54, alpha: 0.63)) {
        let path = GMSMutablePath()
        
        for point in points {
            path.add(point)
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = color ?? .blue
        polyline.strokeWidth = width ?? 5.0
        polyline.map = mapView
    }
}
