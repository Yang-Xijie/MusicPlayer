import AVKit
import SwiftUI
import XCLog

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying = false

    @State var songLibrary: [Song] = [
        Song(name: "君の笑う声", url: Bundle.main.url(forResource: "君の笑う声", withExtension: "mp3")!),
        Song(name: "地平线", url: Bundle.main.url(forResource: "地平线", withExtension: "m4a")!),
    ]

    let defaultSong = Song(name: "君の笑う声", url: Bundle.main.url(forResource: "君の笑う声", withExtension: "mp3")!)
    @State var currentSong: Song

    init() {
        self._audioPlayer = State(initialValue: try! AVAudioPlayer(contentsOf: defaultSong.url))
        self._currentSong = State(initialValue: defaultSong)
    }

    var body: some View {
        VStack {
            Text(currentSong.name)
                .font(.title)
            Button(action: {
                if audioPlayer.isPlaying {
                    self.audioPlayer.pause()
                    isPlaying.toggle()
                } else {
                    self.audioPlayer.play()
                    isPlaying.toggle()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 60))
            }
        }
        .padding()
        .onAppear {
            XCLog(.trace)
        }
    }
}
