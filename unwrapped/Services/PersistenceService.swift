import Foundation

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
        let name = suggestedName?.replacingOccurrences(of: " ", with: "_") ?? UUID().uuidString
        let url = try mediaDirectory().appendingPathComponent(name).appendingPathExtension("jpg")
        try data.write(to: url, options: .atomic)
        return url
    }
}
