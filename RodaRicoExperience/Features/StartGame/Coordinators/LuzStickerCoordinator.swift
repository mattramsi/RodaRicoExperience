//
//  LuzStickerCoordinator.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import ARKit
import RealityKit
import SwiftUI

final class LuzStickerCoordinator: NSObject, ARSessionDelegate {
    var viewModel: StartGameViewModel
    private weak var arView: ARView?
    private var hasDetectedLuz = false
    
    init(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
        print("🔧 Coordinator setup complete for Luz Sticker Scanner")
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                print("🎯 New image anchor added: \(imageAnchor.referenceImage.name ?? "Unknown")")
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
                        print("👁️ Tracking: \(anchorName)")
                    } else {
                        print("👁️ Lost tracking: \(anchorName)")
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARImageAnchor {
                print("🗑️ Image anchor removed: \(anchor)")
                DispatchQueue.main.async {
                    self.viewModel.isTrackingActive = false
                }
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("❌ AR Session failed: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("⚠️ AR Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("✅ AR Session interruption ended")
        // Reconfigurar a sessão após interrupção
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reconfigureSession()
        }
    }
    
    private func reconfigureSession() {
        guard let arView = arView else { return }
        print("🔄 Reconfiguring AR session after interruption...")
        
        // Pausar e limpar
        arView.session.pause()
        
        // Reconfigurar com o sticker "luz"
        let configuration = ARImageTrackingConfiguration()
        if let image = UIImage(named: "luz"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Luz"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("✅ Session reconfigured for sticker: luz")
        }
    }
    
    private func handleImageDetected(_ imageAnchor: ARImageAnchor) {
        let stickerName = imageAnchor.referenceImage.name ?? "Unknown Sticker"
        print("🎯 Sticker detected: \(stickerName)")
        
        // Verificar se é o sticker correto e se ainda não foi detectado
        if stickerName == "Sticker_Luz" && !hasDetectedLuz {
            hasDetectedLuz = true
            print("🎉 Luz sticker detected successfully!")

            DispatchQueue.main.async {
                self.viewModel.currentView = .luzScannerSuccess
            }
            
            // Add visual feedback
            addVisualIndicator(at: imageAnchor)
            
            // Remove anchor after detection
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.arView?.session.remove(anchor: imageAnchor)
            }
        } else if stickerName != "Sticker_Luz" {
            print("⚠️ Wrong sticker detected: \(stickerName) - ignoring")
            // Remover imediatamente stickers incorretos
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.arView?.session.remove(anchor: imageAnchor)
            }
        }
    }
    
    private func addVisualIndicator(at imageAnchor: ARImageAnchor) {
        guard let arView = arView else { return }
        
        // Create success text
        let textEntity = ModelEntity()
        let textMesh = MeshResource.generateText(
            "Luz Detectada!",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .green, isMetallic: false)
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
