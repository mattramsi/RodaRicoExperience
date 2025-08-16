//
//  StartGameARCoordinator.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import ARKit
import RealityKit

final class StartGameARCoordinator: NSObject, ARSessionDelegate {
    // MARK: - Properties
    private let viewModel: StartGameViewModel
    private weak var arView: ARView?
    var onResetRequested: (() -> Void)?
    
    // MARK: - Initialization
    init(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
    }
    
    func configureARSession() {
        guard let arView = arView else { return }
        
        print("🔄 Configuring AR Session for fone sticker...")
        
        // Pausar e limpar a sessão atual primeiro
        arView.session.pause()
        
        // Limpar todos os anchors existentes
        if let currentFrame = arView.session.currentFrame {
            for anchor in currentFrame.anchors {
                arView.session.remove(anchor: anchor)
                print("🗑️ Removed existing anchor: \(anchor)")
            }
        }
        
        // Aguardar um pouco antes de reconfigurar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let configuration = self.createImageTrackingConfiguration()
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("✅ AR Session reconfigured with fresh tracking")
        }
    }
    
    func resetARSession() {
        guard let arView = arView else { return }
        
        print("🔄 Manual AR Session reset requested...")
        configureARSession()
        
        // Notificar o ViewModel sobre o reset
        onResetRequested?()
    }
    
    // MARK: - Private Methods
    private func createImageTrackingConfiguration() -> ARImageTrackingConfiguration {
        let configuration = ARImageTrackingConfiguration()
        
        if let referenceImage = createRocketReferenceImage() {
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        return configuration
    }
    
    private func createRocketReferenceImage() -> ARReferenceImage? {
        guard let image = UIImage(named: "fone"),
              let cgImage = image.cgImage else {
            print("Rocket reference image not found")
            return nil
        }
        
        let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
        referenceImage.name = "Rocket_Reference"
        
        return referenceImage
    }
    
    private func handleRocketDetection(_ imageAnchor: ARImageAnchor) {
        DispatchQueue.main.async {
            self.viewModel.handleRocketDetection()
        }
        
        addVisualFeedback(at: imageAnchor)
        removeAnchorAfterDelay(imageAnchor)
    }
    
    private func addVisualFeedback(at imageAnchor: ARImageAnchor) {
        guard let arView = arView else { return }
        
        let feedbackEntity = createFeedbackEntity()
        let anchorEntity = AnchorEntity()
        anchorEntity.anchoring = AnchoringComponent(.anchor(identifier: imageAnchor.identifier))
        anchorEntity.addChild(feedbackEntity)
        
        arView.scene.addAnchor(anchorEntity)
    }
    
    private func createFeedbackEntity() -> ModelEntity {
        let textMesh = MeshResource.generateText(
            "Rocket Detected!",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let entity = ModelEntity()
        entity.model = ModelComponent(mesh: textMesh, materials: [material])
        entity.position = [0, 0.05, 0]
        
        return entity
    }
    
    private func removeAnchorAfterDelay(_ imageAnchor: ARImageAnchor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.arView?.session.remove(anchor: imageAnchor)
        }
    }
    
    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                handleRocketDetection(imageAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                DispatchQueue.main.async {
                    self.viewModel.isTrackingActive = imageAnchor.isTracked
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
}

