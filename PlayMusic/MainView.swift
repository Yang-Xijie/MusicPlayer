import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @State var songLibrary: [Song] = [
        Song(name: "君の笑う声", url: Bundle.main.url(forResource: "君の笑う声", withExtension: "mp3")!),
        Song(name: "地平线", url: Bundle.main.url(forResource: "地平线", withExtension: "m4a")!),
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(songLibrary, id: \.name) { song in
                    NavigationLink {
                        PlayerView(song: song)
                            .navigationTitle(song.name)
                    } label: {
                        Text(song.name)
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem {
                    Button(action: ImportUserSongFromFile) {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                }
            }

            Image(systemName: "music.note")
                .foregroundColor(.gray)
                .font(.system(size: 72))
                .navigationTitle("Now Playing")
        }

        .onAppear {
            XCLog()
        }
    }

    private func ImportUserSongFromFile() {
        XCLog()
        // TODO: fetch song to app sandbox; add song to songLibrary
    }
}
