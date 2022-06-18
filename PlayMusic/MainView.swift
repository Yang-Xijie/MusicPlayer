import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    // update progress
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State var audioPlayer: AVAudioPlayer?
    var audioPlayerDelegate = PlayerDelegate()
    @State var isPlaying = false
    @State var progress = 0.0 // [0.0, 1.0]

    @State var songLibrary: [Song] = [
        Song(name: "Sorrow Rain", url: Bundle.main.url(forResource: "Sorrow Rain", withExtension: "mp3")!),
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
                                VStack {
                                    HStack {
                                        Text(audioPlayer == nil ? "-:-" : "\(audioPlayer!.currentTime.string)")
                                        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-progress-on-a-task-using-progressview
                                        ProgressView(value: progress, total: 1.0)
                                            .onReceive(timer) { _ in
//                                                XCLog()
                                                progress = audioPlayer == nil ? 0.0 : (audioPlayer!.currentTime / audioPlayer!.duration)
                                            }
                                        Text(audioPlayer == nil ? "-:-" : "\(audioPlayer!.duration.string)")
                                    }
                                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                                        .font(.system(size: 60))
                                }
                                .padding()
                                .edgesIgnoringSafeArea(.bottom)
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
        audioPlayer!.delegate = audioPlayerDelegate
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

class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        XCLog()
        
    }
}
