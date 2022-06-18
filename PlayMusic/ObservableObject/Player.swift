import AVKit
import Foundation
import XCLog

class Player: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var audioPlayerDelegate: PlayerDelegate?
    @Published var isPlaying = false
    @Published var progress: Double? = nil
    @Published var position: Double? = nil
    @Published var duration: Double? = nil

    init() {
        XCLog()
        self.audioPlayerDelegate = PlayerDelegate(player: self)
    }

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
        } else {
            isPlaying = false
        }
    }

    func finishPlaying() {
        XCLog()

        isPlaying = false
    }

    func updateProgress() {
        if let player = audioPlayer {
            progress = player.currentTime / player.duration
            position = player.currentTime
            duration = player.duration
        } else {
            progress = nil
        }
    }
}

class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var player: Player

    init(player: Player) {
        self.player = player
    }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        XCLog()
        player.finishPlaying()
    }
}
