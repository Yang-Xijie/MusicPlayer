import Foundation

extension TimeInterval {
    var string: String {
        let seconds = Int(self)
        let sec = seconds % 60
        let min = seconds / 60
        return "\(min):\(String(format: "%02d", sec))"
    }
}
