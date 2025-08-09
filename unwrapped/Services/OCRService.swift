import Foundation
import Vision
import UIKit

struct OCRParseResult {
    var distanceKM: Double?
    var elevationM: Double?
    var timeHours: Double?
}

enum OCRService {
    static func parseStravaScreenshot(_ image: UIImage) async -> OCRParseResult {
        var result = OCRParseResult()
        guard let cgImage = image.cgImage else { return result }
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
        let texts = (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }
        let blob = texts.joined(separator: " ")

        // Simple number scraping heuristics
        if let km = matchNumber(in: blob, patterns: ["([0-9]+\\.?[0-9]*)\\s?km", "([0-9]+\\.?[0-9]*)\\s?Kilometers"]) { result.distanceKM = km }
        if let meters = matchNumber(in: blob, patterns: ["([0-9]+)\\s?m\\b", "([0-9]+)\\s?meters"]) { result.elevationM = meters }
        if let h = matchTimeHours(in: blob) { result.timeHours = h }
        return result
    }

    private static func matchNumber(in text: String, patterns: [String]) -> Double? {
        for p in patterns {
            if let r = try? NSRegularExpression(pattern: p, options: .caseInsensitive) {
                let ns = text as NSString
                if let m = r.firstMatch(in: text, options: [], range: NSRange(location: 0, length: ns.length)), m.numberOfRanges > 1 {
                    let s = ns.substring(with: m.range(at: 1))
                    if let v = Double(s.replacingOccurrences(of: ",", with: ".")) { return v }
                }
            }
        }
        return nil
    }

    private static func matchTimeHours(in text: String) -> Double? {
        // Matches formats like 1h 23m, 45m, 02:13:00
        if let r = try? NSRegularExpression(pattern: "(?:(\\d+)h)?\\s?(\\d+)m", options: .caseInsensitive) {
            let ns = text as NSString
            if let m = r.firstMatch(in: text, options: [], range: NSRange(location: 0, length: ns.length)) {
                let h = m.range(at: 1).location != NSNotFound ? Double(ns.substring(with: m.range(at: 1))) ?? 0 : 0
                let min = Double(ns.substring(with: m.range(at: 2))) ?? 0
                return h + min/60.0
            }
        }
        if let r = try? NSRegularExpression(pattern: "(\\d{1,2}):(\\d{2})(?::(\\d{2}))?", options: []) {
            let ns = text as NSString
            if let m = r.firstMatch(in: text, options: [], range: NSRange(location: 0, length: ns.length)) {
                let h = Double(ns.substring(with: m.range(at: 1))) ?? 0
                let min = Double(ns.substring(with: m.range(at: 2))) ?? 0
                let sec = m.range(at: 3).location != NSNotFound ? Double(ns.substring(with: m.range(at: 3))) ?? 0 : 0
                return h + min/60.0 + sec/3600.0
            }
        }
        return nil
    }
}

