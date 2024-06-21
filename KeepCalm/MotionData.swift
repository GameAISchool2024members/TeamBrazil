import Foundation

struct MotionData: Codable, Identifiable, Hashable {
    var id = UUID()
    var type: String
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
}
