import AVKit
import Foundation
import XCLog

final class AudioPlayer: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var audioPlayerDelegate: PlayerDelegate?
    @Published public var isPlaying = false
    @Published public var progress: Double? = nil
    @Published public var position: Double? = nil
    @Published public var duration: Double? = nil
    var timer = Timer()
    public init() {
        XCLog()

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                          repeats: true) { _ in
            self.updateProgress()
        }

        self.audioPlayerDelegate = PlayerDelegate(player: self)
    }

    public func prepareAudio(url: URL) {
        XCLog()

        audioPlayer?.stop() // audioPlayer == nil -> won't call
        isPlaying = false

        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer!.delegate = audioPlayerDelegate

        audioPlayer!.enableRate = true // should set `enableRate` to true before the first play
    }

    public func prepareAndStartPlayingAudio(url: URL) {
        XCLog()

        prepareAudio(url: url)

        audioPlayer!.play()
        isPlaying = true
    }

    public func playpauseAudio() {
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

    public func finishPlaying() {
        XCLog()

        isPlaying = false
    }

    public func updateProgress() {
        if let player = audioPlayer {
            progress = player.currentTime / player.duration
            position = player.currentTime
            duration = player.duration
        } else {
            progress = nil
        }
    }

    public func goto(seconds: Double) {
        if let player = audioPlayer, seconds >= 0.0, seconds < player.duration {
            player.currentTime = seconds
        }
    }

    public func gobackward(seconds: Double) {
        if let player = audioPlayer {
            if player.currentTime - seconds < 0.0 {
                player.currentTime = 0.0
            } else {
                player.currentTime = player.currentTime - seconds
            }
        }
    }

    public func goforward(seconds: Double) {
        if let player = audioPlayer {
            if player.currentTime + seconds >= player.duration {
                player.currentTime = player.duration - 2.0
            } else {
                player.currentTime = player.currentTime + seconds
            }
        }
    }

    // accepts [0.5, 2.0]
    public func setPlaySpeed(_ speed: Float) {
        if speed < 0.5 || speed > 2.0 {
            XCLog(.error, "invalid speed")
            return
        }
        self.audioPlayer?.rate = speed
    }
}

final class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    private var player: AudioPlayer

    public init(player: AudioPlayer) {
        self.player = player
    }

    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        XCLog()
        player.finishPlaying()
    }
}
