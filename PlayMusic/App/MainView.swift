import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @ObservedObject var player = Player()
    @ObservedObject var library = Library()

    @State private var isPresentingAudioFileImporter = false

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
                                Button(action: {
                                    withAnimation {
                                        player.playpauseCurrentSong()
                                    }
                                }) {
                                    Image(systemName: player.isPlaying ? "pause.circle" : "play.circle")
                                        .font(.system(size: 60))
                                }
                                .edgesIgnoringSafeArea(.bottom)
                            }
                            .padding()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //        https://stackoverflow.com/questions/69613669/swiftui-fileimporter-cannot-show-again-after-dismissing-by-swipe-down
                        if isPresentingAudioFileImporter {
                            // NOTE: Fixes broken fileimporter sheet not resetting on swipedown
                            isPresentingAudioFileImporter = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPresentingAudioFileImporter = true
                            }
                        } else {
                            isPresentingAudioFileImporter = true
                        }
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .fileImporter(isPresented: $isPresentingAudioFileImporter,
                          allowedContentTypes: [.audio]) { result in
                do {
                    let fileUrl = try result.get()
                    library.ImportUserSongFromFilesApp(url: fileUrl)
                    isPresentingAudioFileImporter = false
                } catch {
                    XCLog(.error, error.localizedDescription)
                }
                isPresentingAudioFileImporter = false
            }

            // when app starts
            Image(systemName: "music.note")
                .foregroundColor(.gray)
                .font(.system(size: 144))
        }
    }
}
