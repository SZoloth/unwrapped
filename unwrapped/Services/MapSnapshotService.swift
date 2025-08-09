import Foundation
import MapKit
import SwiftUI

enum MapSnapshotService {
    static func snapshot(for coordinates: [CLLocationCoordinate2D], size: CGSize) async throws -> UIImage {
        var region = MKCoordinateRegion()
        if let first = coordinates.first {
            var minLat = first.latitude, maxLat = first.latitude
            var minLon = first.longitude, maxLon = first.longitude
            for c in coordinates {
                minLat = min(minLat, c.latitude); maxLat = max(maxLat, c.latitude)
                minLon = min(minLon, c.longitude); maxLon = max(maxLon, c.longitude)
            }
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.8 + 0.02,
                                        longitudeDelta: (maxLon - minLon) * 1.8 + 0.02)
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLon + maxLon)/2)
            region = MKCoordinateRegion(center: center, span: span)
        }

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        options.showsBuildings = true
        options.mapType = .standard

        let snapshotter = MKMapSnapshotter(options: options)
        let image = try await snapshotter.start()
        return image
    }
}

