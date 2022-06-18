import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @State var progress = 0.0 // [0.0, 1.0]

    // update progress
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//
//    @State var audioPlayer: AVAudioPlayer?
//    var audioPlayerDelegate = PlayerDelegate()
//    @State var isPlaying = false

    @ObservedObject var player = Player()

    @ObservedObject var library = Library()

    var body: some View {
        NavigationView {
            List {
                ForEach(library.songs, id: \.name) { song in
                    NavigationLink {
                        VStack {
                            Spacer()
                            Image(systemName: "music.note")
                                .font(.system(size: 144))
                                .foregroundColor(player.isPlaying ? .black : .gray)
                            Spacer()
                            Divider()
                            Button(action: {
                                withAnimation {
                                    player.playpauseCurrentSong()
                                }
                            }) {
                                VStack {
                                    HStack {
                                        Text(player.audioPlayer == nil ? "-:-" : "\(player.audioPlayer!.currentTime.string)")
                                        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-progress-on-a-task-using-progressview
                                        ProgressView(value: progress, total: 1.0)
                                            .onReceive(timer) { _ in
//                                                XCLog()
                                                progress = player.audioPlayer == nil ? 0.0 : (player.audioPlayer!.currentTime / player.audioPlayer!.duration)
                                            }
                                        Text(player.audioPlayer == nil ? "-:-" : "\(player.audioPlayer!.duration.string)")
                                    }
                                    Image(systemName: player.isPlaying ? "pause.circle" : "play.circle")
                                        .font(.system(size: 60))
                                }
                                .padding()
                                .edgesIgnoringSafeArea(.bottom)
                            }
                        }
                        .padding()
                        .onAppear {
                            player.playNewSong(song)
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
                    Button(action: library.ImportUserSongFromFile) {
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

//    private func playNewSong(_ song: Song) {
//        XCLog()
//
//        audioPlayer?.stop() // audioPlayer == nil -> won't call
//        isPlaying = false
//
//        audioPlayer = try! AVAudioPlayer(contentsOf: song.url)
//        audioPlayer!.delegate = audioPlayerDelegate
//        audioPlayer!.play()
//        isPlaying = true
//    }
//
//    private func playpauseCurrentSong() {
//        XCLog()
//
//        if let player = audioPlayer {
//            if player.isPlaying {
//                player.pause()
//                isPlaying.toggle()
//            } else {
//                player.play()
//                isPlaying.toggle()
//            }
//        }
//    }

//    private func ImportUserSongFromFile() {
//        XCLog()
//
//        // TODO: fetch song to app sandbox; add song to songLibrary
//    }
}
