import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @State var audioPlayer: AVAudioPlayer?
    @State var isPlaying = false

    @State var songLibrary: [Song] = [
        Song(name: "君の笑う声", url: Bundle.main.url(forResource: "君の笑う声", withExtension: "mp3")!),
        Song(name: "地平线", url: Bundle.main.url(forResource: "地平线", withExtension: "m4a")!),
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(songLibrary, id: \.name) { song in
                    NavigationLink {
                        VStack {
                            Spacer()
                            Image(systemName: "music.note")
                                .font(.system(size: 144))
                                .foregroundColor(isPlaying ? .black : .gray)
                            Spacer()
                            Divider()
                            Button(action: {
                                withAnimation {
                                    playpauseCurrentSong()
                                }
                            }) {
                                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                                    .font(.system(size: 60))
                            }
                        }
                        .padding()
                        .onAppear {
                            playNewSong(song)
                        }
                        .navigationTitle(song.name)
                        .edgesIgnoringSafeArea(.bottom)
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

            // when app starts
            Image(systemName: "music.note")
                .foregroundColor(.gray)
                .font(.system(size: 144))
        }
    }

    private func playNewSong(_ song: Song) {
        XCLog()

        audioPlayer?.stop() // audioPlayer == nil -> won't call
        isPlaying = false

        audioPlayer = try! AVAudioPlayer(contentsOf: song.url)
        audioPlayer!.play()
        isPlaying = true
    }

    private func playpauseCurrentSong() {
        XCLog()

        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                isPlaying.toggle()
            } else {
                player.play()
                isPlaying.toggle()
            }
        }
    }

    private func ImportUserSongFromFile() {
        XCLog()

        // TODO: fetch song to app sandbox; add song to songLibrary
    }
}
