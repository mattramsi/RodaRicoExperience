//
//  StickerTrackingARView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

// MARK: - Main View
struct StickerTrackingARView: View {
    @StateObject private var viewModel: StickerTrackingViewModel
    let stickerName: String
    let stickerImageName: String
    
    init(stickerName: String, stickerImageName: String) {
        self.stickerName = stickerName
        self.stickerImageName = stickerImageName
        self._viewModel = StateObject(wrappedValue: StickerTrackingViewModel(stickerName: stickerName))
    }
    
    var body: some View {
        ZStack {
            // AR Container
            StickerTrackingContainerView(
                viewModel: viewModel,
                stickerImageName: stickerImageName
            )
            .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            StickerTrackingOverlayView(viewModel: viewModel)
            
            // Popup Modal
            if viewModel.isPopupVisible {
                StickerPopupView(
                    isVisible: $viewModel.isPopupVisible,
                    stickerName: viewModel.detectedStickerName,
                    detectionCount: viewModel.detectionCount
                )
            }
        }
        .navigationTitle("Escaneando \(stickerName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Model
@MainActor
final class StickerTrackingViewModel: ObservableObject {
    @Published var isPopupVisible = false
    @Published var detectedStickerName = ""
    @Published var isTrackingActive = false
    @Published var detectionCount = 0
    
    let stickerName: String
    
    init(stickerName: String) {
        self.stickerName = stickerName
    }
    
    func showPopup(for stickerName: String) {
        detectedStickerName = stickerName
        detectionCount += 1
        isPopupVisible = true
        
        // Auto-hide popup after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isPopupVisible = false
        }
    }
    
    func resetDetection() {
        // Reset to allow new detections
        isPopupVisible = false
    }
    
    func clearAllAnchors() {
        // Clear all anchors to allow fresh detections
        isPopupVisible = false
    }
    
    func hidePopup() {
        isPopupVisible = false
    }
}

// MARK: - AR Container View
struct StickerTrackingContainerView: UIViewRepresentable {
    let viewModel: StickerTrackingViewModel
    let stickerImageName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        configureARSession(for: arView, imageName: stickerImageName)
        coordinator.setupARView(arView)
        
        // Connect viewModel to coordinator
        coordinator.viewModel = viewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> StickerTrackingCoordinator {
        StickerTrackingCoordinator(viewModel: viewModel, stickerImageName: stickerImageName)
    }
    
    private func configureARSession(for arView: ARView, imageName: String) {
        // Check if image tracking is supported
        guard ARImageTrackingConfiguration.isSupported else {
            print("Image tracking is not supported on this device")
            return
        }
        
        let configuration = ARImageTrackingConfiguration()
        
        // Create a reference image for tracking
        if let image = UIImage(named: imageName),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_\(imageName)"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            print("✅ AR Session configured for sticker: \(imageName)")
            print("✅ Reference image name: \(referenceImage.name ?? "Unknown")")
        } else {
            print("❌ Failed to load image: \(imageName)")
        }
        
        arView.session.run(configuration, options: [])
    }
}

// MARK: - AR Coordinator
final class StickerTrackingCoordinator: NSObject, ARSessionDelegate {
    var viewModel: StickerTrackingViewModel
    private weak var arView: ARView?
    private let stickerImageName: String
    
    init(viewModel: StickerTrackingViewModel, stickerImageName: String) {
        self.viewModel = viewModel
        self.stickerImageName = stickerImageName
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
    }
    
    func clearAllAnchors() {
        guard let arView = arView else { return }
        
        // Remove all existing anchors
        let currentAnchors = arView.session.currentFrame?.anchors ?? []
        for anchor in currentAnchors {
            arView.session.remove(anchor: anchor)
        }
        
        // Reset tracking
        arView.session.pause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let configuration = ARImageTrackingConfiguration()
            if let referenceImage = self.createReferenceImage() {
                configuration.trackingImages = [referenceImage]
                configuration.maximumNumberOfTrackedImages = 1
            }
            arView.session.run(configuration, options: [])
        }
    }
    
    private func createReferenceImage() -> ARReferenceImage? {
        // Create a reference image from your sticker
        print("🔍 Creating reference image for: \(stickerImageName)")
        
        guard let image = UIImage(named: stickerImageName) else {
            print("❌ Reference image not found: \(stickerImageName). Please add your sticker image to Assets.xcassets")
            return nil
        }
        
        print("✅ Image loaded successfully: \(stickerImageName)")
        
        // Convert to CGImage
        guard let cgImage = image.cgImage else {
            print("❌ Failed to convert UIImage to CGImage")
            return nil
        }
        
        // Create reference image with physical size (in meters)
        let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
        referenceImage.name = "Sticker_\(viewModel.stickerName)"
        
        print("✅ Reference image created with name: \(referenceImage.name ?? "Unknown")")
        
        return referenceImage
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                handleImageDetected(imageAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                DispatchQueue.main.async {
                    if imageAnchor.isTracked {
                        self.viewModel.isTrackingActive = true
                    } else {
                        self.viewModel.isTrackingActive = false
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARImageAnchor {
                DispatchQueue.main.async {
                    self.viewModel.isTrackingActive = false
                }
            }
        }
    }
    
    private func handleImageDetected(_ imageAnchor: ARImageAnchor) {
        let stickerName = imageAnchor.referenceImage.name ?? "Unknown Sticker"
        
        DispatchQueue.main.async {
            self.viewModel.showPopup(for: stickerName)
        }
        
        // Add a visual indicator at the detected location
        addVisualIndicator(at: imageAnchor)
        
        // Remove the anchor to allow new detections
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.arView?.session.remove(anchor: imageAnchor)
        }
    }
    
    private func addVisualIndicator(at imageAnchor: ARImageAnchor) {
        guard let arView = arView else { return }
        
        // Create a simple 3D text entity to show detection
        let textEntity = ModelEntity()
        
        // Create text mesh
        let textMesh = MeshResource.generateText(
            "Sticker Detected!",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        // Create material
        let material = SimpleMaterial(color: .green, isMetallic: false)
        
        // Apply mesh and material
        textEntity.model = ModelComponent(mesh: textMesh, materials: [material])
        
        // Position the text above the detected image
        textEntity.position = [0, 0.05, 0]
        
        // Create anchor entity and add text
        let anchorEntity = AnchorEntity()
        anchorEntity.anchoring = AnchoringComponent(.anchor(identifier: imageAnchor.identifier))
        anchorEntity.addChild(textEntity)
        
        // Add to scene
        arView.scene.addAnchor(anchorEntity)
        
        // Remove after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            arView.scene.removeAnchor(anchorEntity)
        }
    }
}

// MARK: - UI Overlay View
struct StickerTrackingOverlayView: View {
    @ObservedObject var viewModel: StickerTrackingViewModel
    
    var body: some View {
        VStack {
            // Status indicator
            HStack {
                Spacer()
                VStack {
                    Circle()
                        .fill(viewModel.isTrackingActive ? Color.green : Color.red)
                        .frame(width: 20, height: 20)
                    Text(viewModel.isTrackingActive ? "Tracking" : "Searching")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding()
            }
            
            Spacer()
            
            // Instructions
            VStack {
                Text("Aponte sua câmera para o sticker \(viewModel.stickerName)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("O app detectará automaticamente")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text("Detecções: \(viewModel.detectionCount)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 5)
                
                Button("Nova Detecção") {
                    // Clear all anchors and reset tracking
                    viewModel.clearAllAnchors()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.top, 10)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
        }
    }
}

// MARK: - Popup Modal View
struct StickerPopupView: View {
    @Binding var isVisible: Bool
    let stickerName: String
    let detectionCount: Int
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isVisible = false
                }
            
            // Popup content
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Sticker Detectado!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Identificado com sucesso:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(stickerName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Detecção #\(detectionCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
                
                Button("OK") {
                    isVisible = false
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding(30)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        StickerTrackingARView(stickerName: "Luz", stickerImageName: "luz")
    }
}
