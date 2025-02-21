//
//  MapController.swift
//  here-map-package
//
//  Created by Ankush Kushwaha on 21/02/25.
//

import UIKit
import CoreLocation
import SwiftUI

public protocol MapController {
//    associatedtype MapViewType: UIViewRepresentable
    func mapUIRepresentable() -> AnyView

    static var shared: (any MapController)? { get }


    func addMarkers(_ markers: [MarkerWithData])

    func addMarkerCluster(_ markers: [MarkerWithData],
                          clusterImage: UIImage)
    func moveCamera(_ point: CLLocationCoordinate2D,
                           zoomLevel: Float?)

    func drawRoute(_ points: [CLLocationCoordinate2D],
                   width: CGFloat?, color: UIColor?)
    func clearMap()
}


public struct MarkerWithData {
    public let coordinates: CLLocationCoordinate2D
    public let metaData: [String: String]
    public let image: UIImage

    public init(coordinates: CLLocationCoordinate2D,
                metaData: [String : String],
                image: UIImage) {
        self.coordinates = coordinates
        self.metaData = metaData
        self.image = image
    }
}
