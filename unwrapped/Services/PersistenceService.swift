import Foundation
import UniformTypeIdentifiers
import ImageIO

enum PersistenceService {
    static func projectDirectory() throws -> URL {
        let dir = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("YearInReview", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func save(_ project: YearInReviewProject) throws -> URL {
        let url = try projectDirectory().appendingPathComponent("project-\(project.id).json")
        let data = try JSONEncoder().encode(project)
        try data.write(to: url, options: .atomic)
        return url
    }

    static func load(url: URL) throws -> YearInReviewProject {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(YearInReviewProject.self, from: data)
    }

    static func allProjectFiles() throws -> [URL] {
        let dir = try projectDirectory()
        let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles])
        return files.filter { $0.lastPathComponent.hasPrefix("project-") && $0.pathExtension == "json" }
    }

    static func latestProjectURL() throws -> URL? {
        let files = try allProjectFiles()
        return files.max(by: { (a, b) -> Bool in
            let da = (try? a.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            let db = (try? b.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return da < db
        })
    }

    static func mediaDirectory() throws -> URL {
        let dir = try projectDirectory().appendingPathComponent("Media", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func saveImageData(_ data: Data, suggestedName: String? = nil) throws -> URL {
        let name = (suggestedName ?? UUID().uuidString).replacingOccurrences(of: " ", with: "_")
        let ext = detectImageExtension(from: data) ?? "jpg"
        let url = try mediaDirectory().appendingPathComponent(name).appendingPathExtension(ext)
        try data.write(to: url, options: .atomic)
        return url
    }

    static func copyIntoMedia(from sourceURL: URL) throws -> URL {
        let destDir = try mediaDirectory()
        let destURL = destDir.appendingPathComponent(sourceURL.lastPathComponent)
        let fm = FileManager.default
        if fm.fileExists(atPath: destURL.path) {
            let unique = UUID().uuidString
            let ext = sourceURL.pathExtension
            let base = sourceURL.deletingPathExtension().lastPathComponent
            let alt = destDir.appendingPathComponent("\(base)-\(unique)").appendingPathExtension(ext)
            try fm.copyItem(at: sourceURL, to: alt)
            return alt
        } else {
            try fm.copyItem(at: sourceURL, to: destURL)
            return destURL
        }
    }

    private static func detectImageExtension(from data: Data) -> String? {
        guard let src = CGImageSourceCreateWithData(data as CFData, nil),
              let uti = CGImageSourceGetType(src) as String? else { return nil }
        if let type = UTType(uti) {
            if type.conforms(to: .jpeg) { return "jpg" }
            if type.conforms(to: .png) { return "png" }
            if type.conforms(to: .heic) { return "heic" }
            if type.conforms(to: .tiff) { return "tiff" }
        }
        return nil
    }
}
