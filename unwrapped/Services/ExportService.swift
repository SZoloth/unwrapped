import Foundation
import Compression
import SwiftUI

@MainActor
enum ExportService {
    static func renderPNG<V: View>(of view: V, scale: CGFloat = 3.0) -> Data? {
        // Render at 1080x1920 by scaling the preview-sized CardFrame
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        return renderer.uiImage?.pngData()
    }

    static func exportCards(_ views: [AnyView]) throws -> [URL] {
        let dir = try PersistenceService.projectDirectory().appendingPathComponent("Exports-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        var urls: [URL] = []
        for (idx, v) in views.enumerated() {
            if let data = renderPNG(of: v) {
                let url = dir.appendingPathComponent(String(format: "card-%02d.png", idx+1))
                try data.write(to: url)
                urls.append(url)
            }
        }
        return urls
    }

    nonisolated static func cleanupOldExports() {
        guard let dir = try? PersistenceService.projectDirectory() else { return }
        let fm = FileManager.default
        guard let items = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { return }
        for url in items where url.lastPathComponent.hasPrefix("Exports-") {
            try? fm.removeItem(at: url)
        }
    }

    /// Creates a simple archive by copying files to a folder (ZIP functionality requires external library)
    nonisolated static func zipExports(_ files: [URL]) throws -> URL {
        let dir = try PersistenceService.projectDirectory()
        let archiveDir = dir.appendingPathComponent("YearInReview-Exports-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: archiveDir, withIntermediateDirectories: true)
        for file in files {
            let dest = archiveDir.appendingPathComponent(file.lastPathComponent)
            try FileManager.default.copyItem(at: file, to: dest)
        }
        return archiveDir
    }
}
