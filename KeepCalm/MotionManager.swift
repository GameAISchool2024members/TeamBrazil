import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    @Published var accelerometerData: CMAccelerometerData?
    @Published var gyroData: CMGyroData?

    public init() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1

        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                if let data = data {
                    self?.accelerometerData = data
                }
            }
        }

        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                if let data = data {
                    self?.gyroData = data
                }
            }
        }
    }
}
