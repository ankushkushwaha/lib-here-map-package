// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "here-map-package",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "GoogleMapsPackage",
            targets: ["GoogleMapTarget"]
        ),
        .library(
            name: "HereMapPackage",
            targets: ["HereMapTarget"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", from: "9.3.0"),
        .package(url: "https://github.com/googlemaps/google-maps-ios-utils", from: "6.1.0")
    ],
    targets: [
        // ✅ Common Interface Target
       .target(
            name: "CommonMapInterface",
            path: "Sources/CommonMapInterface"
        ),
       
        // ✅ Google Maps Target
        .target(
            name: "GoogleMapTarget",
            dependencies: [
                "CommonMapInterface",
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "GoogleMapsUtils", package: "google-maps-ios-utils")
            ],
            path: "Sources/GoogleMaps"
        ),

        // ✅ HERE Maps Target
        .target(
            name: "HereMapTarget",
            dependencies: [
                "CommonMapInterface",
                .target(name: "HereSDKBinary") // Link the binary framework
            ],
            path: "Sources/HereMaps"
        ),

        // ✅ Binary Target for HERE SDK
        .binaryTarget(
            name: "HereSDKBinary",
            path: "Frameworks/heresdk.xcframework"
        )
    ]
)
