import AVKit
import SwiftUI
import XCLog

struct PlayerView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying = false

    @State var currentSong: Song

    init(song: Song) {
        self._audioPlayer = State(initialValue: try! AVAudioPlayer(contentsOf: song.url))
        self._currentSong = State(initialValue: song)
//        TODO: audioPlayer.reset
    }

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "music.note")
                .font(.system(size: 144))
            Spacer()
            Divider()
            Button(action: {
                if audioPlayer.isPlaying {
                    self.audioPlayer.pause()
                    isPlaying.toggle()
                } else {
                    self.audioPlayer.play()
                    isPlaying.toggle()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .font(.system(size: 60))
            }
        }
        .padding()
        .onAppear {
            XCLog()
        }
        .onDisappear {
            XCLog()
            audioPlayer.pause()
            
        }
    }
}
