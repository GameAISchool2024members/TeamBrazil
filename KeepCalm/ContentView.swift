import SwiftUI
import MultipeerKit
import Combine
import SpriteKit
import CoreHaptics

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @EnvironmentObject var dataSource: MultipeerDataSource
    
    @State private var showErrorAlert = false
    @State private var gameScene: GameScene?
    @State private var showPeers = false
    @State private var engine: CHHapticEngine?
    
    init(transceiver: MultipeerTransceiver) {
        self.viewModel = ViewModel(transceiver: transceiver)
        if UIDevice.current.userInterfaceIdiom == .phone {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadView
            } else {
                iPhoneView
                    .onAppear(perform: {
                        prepareHaptics()
                    })
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Please select a peer"), message: nil, dismissButton: .default(Text("OK")))
        }
    }
    
    var iPadView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPeers.toggle()
                }) {
                    Image(systemName: "person.2.fill")
                        .font(.title)
                        .padding()
                }
            }
            .padding()
            
            SpriteKitView(gameScene: $gameScene)
                .onChange(of: viewModel.latestMotionData) { _, newValue in
                    if let data = newValue {
                        DispatchQueue.main.async {
                            gameScene?.updateMotionData(data)
                            triggerHapticFeedback()
                        }
                    }
                }
                .sheet(isPresented: $showPeers) {
                    peerListView
                }
                .padding(.all)
        }
    }
    
    var iPhoneView: some View {
        VStack {
            peerListView
            
            if let latestMotionData = viewModel.latestMotionData {
                VStack {
                    Text("Latest Motion Data:")
                    Text("Type: \(latestMotionData.type)")
                    Text("X: \(latestMotionData.x)")
                    Text("Y: \(latestMotionData.y)")
                    Text("Z: \(latestMotionData.z)")
                }
                .padding()
            }
        }
    }
    
    var peerListView: some View {
        VStack(alignment: .leading) {
            Text("Peers").font(.headline).padding()
            
            List {
                ForEach(dataSource.availablePeers) { peer in
                    HStack {
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(peer.isConnected ? .green : .gray)
                        
                        Text(peer.name)
                        
                        Spacer()
                        
                        if viewModel.selectedPeers.contains(peer) {
                            Image(systemName: "checkmark")
                                .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: peer)
                        }
                    }
                    .onTapGesture {
                        viewModel.toggle(peer)
                    }
                }
            }
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func triggerHapticFeedback() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
