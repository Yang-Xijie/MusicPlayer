import Foundation
import XCLog

class Library: ObservableObject {
    @Published var songs: [Song] = [
        Song(name: "Sorrow Rain", url: Bundle.main.url(forResource: "Sorrow Rain", withExtension: "mp3")!),
        Song(name: "君の笑う声", url: Bundle.main.url(forResource: "君の笑う声", withExtension: "mp3")!),
        Song(name: "地平线", url: Bundle.main.url(forResource: "地平线", withExtension: "m4a")!),
    ]
    
    func ImportUserSongFromFile() {
        XCLog()

        // TODO: fetch song to app sandbox; add song to songLibrary
    }
}
