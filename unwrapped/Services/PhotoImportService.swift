import Foundation
import PhotosUI
import Photos
import CoreLocation
import UIKit
import ImageIO

struct PhotoImportResult {
    let moments: [Moment]
}

enum PhotoImportService {
    static func extractEXIF(from url: URL) -> (date: Date?, location: CLLocationCoordinate2DWrapper?) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return (nil, nil)
        }
        let exif = props[kCGImagePropertyExifDictionary] as? [CFString: Any]
        let tiff = props[kCGImagePropertyTIFFDictionary] as? [CFString: Any]
        var date: Date? = nil
        if let dateString = (exif?[kCGImagePropertyExifDateTimeOriginal] as? String) ?? (tiff?[kCGImagePropertyTIFFDateTime] as? String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
            date = formatter.date(from: dateString)
        }
        var locationWrapper: CLLocationCoordinate2DWrapper? = nil
        if let gps = props[kCGImagePropertyGPSDictionary] as? [CFString: Any],
           let lat = gps[kCGImagePropertyGPSLatitude] as? Double,
           let lon = gps[kCGImagePropertyGPSLongitude] as? Double {
            locationWrapper = CLLocationCoordinate2DWrapper(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        return (date, locationWrapper)
    }

    static func moments(from urls: [URL]) -> [Moment] {
        urls.map { url in
            let meta = extractEXIF(from: url)
            return Moment(id: UUID(), imageURL: url, caption: nil, date: meta.date, location: meta.location)
        }
    }
}

