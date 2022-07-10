import AVKit
import SwiftUI
import XCLog

struct MainView: View {
    @ObservedObject var player = AudioPlayer()
    @ObservedObject var library = Library()

    @State private var isPresentingAudioFileImporter = false

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
                                    ProgressView(value: player.progress)
                                    Text(player.duration == nil ? "-:-" : player.duration!.string)
                                }
                                .padding([.horizontal])

                                AudioPlayerControlView(player: player)
                            }
                        }
                        .onAppear {
                            player.prepareAndStartPlayingAudio(url: song.url)
                        }
                        .navigationTitle(song.name)
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
