//
//  LuzStickerPhase3Coordinator.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import ARKit
import RealityKit
import SwiftUI

final class LuzStickerPhase3Coordinator: NSObject, ARSessionDelegate {
    var viewModel: StartGameViewModel
    private weak var arView: ARView?
    private var hasDetectedLuzPhase3 = false
    
    init(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
        print("🔧 Phase 3 Coordinator setup complete for Luz Sticker Scanner")
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                print("🎯 Phase 3: New image anchor added: \(imageAnchor.referenceImage.name ?? "Unknown")")
                handleImageDetected(imageAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                let isTracked = imageAnchor.isTracked
                let anchorName = imageAnchor.referenceImage.name ?? "Unknown"
                
                DispatchQueue.main.async {
                    self.viewModel.isTrackingActive = isTracked
                    if isTracked {
                        print("👁️ Phase 3: Tracking: \(anchorName)")
                    } else {
                        print("👁️ Phase 3: Lost tracking: \(anchorName)")
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARImageAnchor {
                print("🗑️ Phase 3: Image anchor removed: \(anchor)")
                DispatchQueue.main.async {
                    self.viewModel.isTrackingActive = false
                }
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("❌ Phase 3: AR Session failed: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("⚠️ Phase 3: AR Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("✅ Phase 3: AR Session interruption ended")
        // Reconfigurar a sessão após interrupção
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reconfigureSession()
        }
    }
    
    private func reconfigureSession() {
        guard let arView = arView else { return }
        print("🔄 Phase 3: Reconfiguring AR session after interruption...")
        
        // Pausar e limpar
        arView.session.pause()
        
        // Reconfigurar com o sticker "luz" da Fase 3
        let configuration = ARImageTrackingConfiguration()
        if let image = UIImage(named: "luz"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Luz_Phase3"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("✅ Phase 3: Session reconfigured for sticker: luz")
        }
    }
    
    private func handleImageDetected(_ imageAnchor: ARImageAnchor) {
        let stickerName = imageAnchor.referenceImage.name ?? "Unknown Sticker"
        print("🎯 Phase 3: Sticker detected: \(stickerName)")
        
        // Verificar se é o sticker correto da Fase 3 e se ainda não foi detectado
        if stickerName == "Sticker_Luz_Phase3" && !hasDetectedLuzPhase3 {
            hasDetectedLuzPhase3 = true
            print("🎉 Phase 3: Luz sticker detected successfully!")
            
            DispatchQueue.main.async {
                self.viewModel.detectionCount += 1
                self.viewModel.isSuccessVisible = true
            }
            
            // Add visual feedback
            addVisualIndicator(at: imageAnchor)
            
            // Remove anchor after detection
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.arView?.session.remove(anchor: imageAnchor)
            }
        } else if stickerName != "Sticker_Luz_Phase3" {
            print("⚠️ Phase 3: Wrong sticker detected: \(stickerName) - ignoring")
            // Remover imediatamente stickers incorretos
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.arView?.session.remove(anchor: imageAnchor)
            }
        }
    }
    
    private func addVisualIndicator(at imageAnchor: ARImageAnchor) {
        guard let arView = arView else { return }
        
        // Create success text for Phase 3
        let textEntity = ModelEntity()
        let textMesh = MeshResource.generateText(
            "Fase 3 - Luz Detectada!",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .orange, isMetallic: false)
        textEntity.model = ModelComponent(mesh: textMesh, materials: [material])
        textEntity.position = [0, 0.05, 0]
        
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        
        // Remove after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            arView.scene.removeAnchor(anchorEntity)
        }
    }
}
