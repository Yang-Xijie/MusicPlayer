import Foundation
import XCLog

class Library: ObservableObject {
    @Published var songs: [Song]

    init() {
        // create music folder
        if !FileManager.default.fileExists(atPath: DocumentMusicFolder.absoluteString) {
            try! FileManager.default.createDirectory(at: DocumentMusicFolder, withIntermediateDirectories: true, attributes: nil)
        }
        // import all songs
        let songUrls = try! FileManager.default.contentsOfDirectory(
            at: DocumentMusicFolder, includingPropertiesForKeys: nil
        )
        self._songs = Published(initialValue: songUrls.map {
            Song(name: $0.deletingPathExtension().lastPathComponent, url: $0)
        })
    }

    func ImportUserSongFromFilesApp(url: URL) {
        XCLog("url: \(url)")

        let songFileName = url.lastPathComponent
        let songName = url.deletingPathExtension().lastPathComponent
        let songPath = DocumentMusicFolder.appendingPathComponent(songFileName)
        if ImportFileFromFilesApp(url, to: songPath) {
            songs.append(Song(name: songName, url: songPath))
        }

        // debug
        let files = try! FileManager.default.contentsOfDirectory(
            at: DocumentMusicFolder, includingPropertiesForKeys: nil
        )
        XCLog(.debug, "\(files.map(\.lastPathComponent))")
    }
}
