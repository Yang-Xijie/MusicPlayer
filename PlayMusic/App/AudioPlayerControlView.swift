import SwiftUI

enum AudioPlayerSpeed {
    case slow_half
    case slow_three_quarters
    case normal
    case fast_five_quarters
    case fast_three_halfs
    case fast_twice

    var speed: Float {
        switch self {
        case .slow_half:
            return 0.5
        case .slow_three_quarters:
            return 0.75
        case .normal:
            return 1.0
        case .fast_five_quarters:
            return 1.25
        case .fast_three_halfs:
            return 1.5
        case .fast_twice:
            return 2.0
        }
    }

    var name: String {
        switch self {
        case .slow_half:
            return "0.5"
        case .slow_three_quarters:
            return "0.75"
        case .normal:
            return "1.0"
        case .fast_five_quarters:
            return "1.25"
        case .fast_three_halfs:
            return "1.5"
        case .fast_twice:
            return "2.0"
        }
    }

    var next: Self {
        switch self {
        case .slow_half:
            return .slow_three_quarters
        case .slow_three_quarters:
            return .normal
        case .normal:
            return .fast_five_quarters
        case .fast_five_quarters:
            return .fast_three_halfs
        case .fast_three_halfs:
            return .fast_twice
        case .fast_twice:
            return .slow_half
        }
    }
}

struct AudioPlayerControlView: View {
    @ObservedObject var player: AudioPlayer

    @State var speed: AudioPlayerSpeed = .normal

    let size0 = CGFloat(48.0) // 中间播放键的大小
    let size1 = CGFloat(30.0) // 两侧小东西的大小

    let speedWidth = CGFloat(60.0) // 左侧调整速度按钮的大小

    var body: some View {
        HStack {
            // MARK: speed

            Button {
                withAnimation {
                    speed = speed.next
                    player.setPlaySpeed(speed.speed)
                }
            } label: {
                Text("x\(speed.name)")
                    .bold()
            }
            .frame(width: speedWidth)
            .padding([.horizontal])

            Spacer()

            // MARK: control

            Group {
                Button {
                    withAnimation {
                        player.gobackward(seconds: 30.0)
                    }
                } label: {
                    Image(systemName: "gobackward.30")
                        .font(.system(size: size1))
                }

                Button {
                    withAnimation {
                        player.gobackward(seconds: 5.0)
                    }
                } label: {
                    Image(systemName: "gobackward.5")
                        .font(.system(size: size1))
                }

                Button {
                    withAnimation {
                        player.playpauseAudio()
                    }
                } label: {
                    Image(systemName: player.isPlaying ? "pause" : "play")
                        .font(.system(size: size0))
                        .frame(width: size0, height: size0) // to prevent dynamic view size change
                }
                .padding([.horizontal])

                Button {
                    withAnimation {
                        player.goforward(seconds: 5.0)
                    }
                } label: {
                    Image(systemName: "goforward.5")
                        .font(.system(size: size1))
                }

                Button {
                    withAnimation {
                        player.goforward(seconds: 30.0)
                    }
                } label: {
                    Image(systemName: "goforward.30")
                        .font(.system(size: size1))
                }
            }

            Spacer()

            // symmetric
            Color.clear
                .frame(width: speedWidth, height: CGFloat(1.0))
        }
    }
}
