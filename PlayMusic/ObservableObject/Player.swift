import AVKit
import Foundation
import XCLog

class Player: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isFinished = false
    var audioPlayerDelegate = PlayerDelegate()

    func playNewSong(_ song: Song) {
        XCLog()

        audioPlayer?.stop() // audioPlayer == nil -> won't call
        isPlaying = false

        audioPlayer = try! AVAudioPlayer(contentsOf: song.url)
        audioPlayer!.delegate = audioPlayerDelegate
        audioPlayer!.play()
        isPlaying = true
    }

    func playpauseCurrentSong() {
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
}

class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        XCLog()
    }
}
