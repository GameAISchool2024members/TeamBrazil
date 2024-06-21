import SwiftUI
import CoreMotion
import MultipeerKit
import Combine
import SpriteKit

final class ViewModel: ObservableObject {
    @Published var selectedPeers: [Peer] = []
    @Published var latestMotionData: MotionData?
    @Published var receivedData: [MotionData] = []
    private var motionManager = CMMotionManager()
    private var timer: AnyCancellable?
    private var transceiver: MultipeerTransceiver

    init(transceiver: MultipeerTransceiver) {
        self.transceiver = transceiver
        self.transceiver.resume()

        self.transceiver.receive(MotionData.self) { [weak self] data, _ in
            DispatchQueue.main.async {
                self?.receivedData.append(data)
                self?.latestMotionData = data
            }
        }

        startSendingMotionData()
    }

    func toggle(_ peer: Peer) {
        if selectedPeers.contains(peer) {
            selectedPeers.remove(at: selectedPeers.firstIndex(of: peer)!)
        } else {
            selectedPeers.append(peer)
        }
    }

    private func startSendingMotionData() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.sendMotionData()
        }

        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        }
    }

    private func sendMotionData() {
        guard !selectedPeers.isEmpty else { return }

        if let deviceMotion = motionManager.deviceMotion {
            let accelData = deviceMotion.userAcceleration
            let gyroData = deviceMotion.rotationRate

            // Combine accelerometer and gyroscope data
            let data = MotionData(
                type: "Combined",
                x: accelData.x + gyroData.x,
                y: accelData.y + gyroData.y,
                z: accelData.z + gyroData.z
            )
            send(data)
            latestMotionData = data
        }
    }

    private func send(_ data: MotionData) {
        transceiver.broadcast(data)
    }
}

