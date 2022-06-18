import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @ObservedObject var player = Player()
    @ObservedObject var library = Library()

    // update progress
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

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
                                        Text(player.position == nil ? "-:-" : player.position!.string)
                                        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-progress-on-a-task-using-progressview
                                        ProgressView(value: player.progress)
                                            .onReceive(timer) { _ in
                                                player.updateProgress()
                                            }
                                        Text(player.duration == nil ? "-:-" : player.duration!.string)
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
}
