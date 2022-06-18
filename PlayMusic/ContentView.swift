import AVKit
import SwiftUI
import XCLog

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying = false

    init() {
//        let song = Bundle.main.path(forResource: "地平线", ofType: "m4a")
        let song = Bundle.main.path(forResource: "君の笑う声", ofType: "mp3")
        self._audioPlayer = State(initialValue: try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: song!)))
    }

    var body: some View {
        VStack {
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
                    .font(.title)
            }
        }
        .onAppear {
            XCLog(.trace)
        }
    }
}
