//
//  MaquiagemStickerCoordinator.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import ARKit
import RealityKit
import SwiftUI

final class MaquiagemStickerCoordinator: NSObject, ARSessionDelegate {
    var viewModel: StartGameViewModel
    private weak var arView: ARView?
    private var hasDetectedMaquiagem = false
    
    init(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
        print("🔧 Coordinator setup complete for Maquiagem Sticker Scanner")
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Log do status da sessão para debug
        if frame.timestamp.truncatingRemainder(dividingBy: 1.0) < 0.1 {
            let cameraTransform = frame.camera.transform
            let trackingState = frame.camera.trackingState
            print("📱 Camera status - Position: \(cameraTransform.columns.3), Tracking: \(trackingState)")
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
        
        // Tentar reconfigurar a sessão em caso de falha
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🔄 Attempting to recover from AR session failure...")
            self.reconfigureSession()
        }
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
        
        // Reconfigurar com o sticker "maquiagem" de forma mais suave
        let configuration = ARImageTrackingConfiguration()
        if let image = UIImage(named: "maquiagem"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Maquiagem"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            arView.session.run(configuration, options: [])
            print("✅ Session reconfigured for sticker: maquiagem")
        }
    }
    
    private func resetARSession() {
        guard let arView = arView else { return }
        print("🔄 Resetting AR session for Maquiagem sticker...")
        
        // Reset mais suave - apenas pausar brevemente e reconfigurar
        arView.session.pause()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let configuration = ARImageTrackingConfiguration()
            if let image = UIImage(named: "maquiagem"),
               let cgImage = image.cgImage {
                let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
                referenceImage.name = "Sticker_Maquiagem"
                configuration.trackingImages = [referenceImage]
                configuration.maximumNumberOfTrackedImages = 1
                
                arView.session.run(configuration, options: [])
                print("✅ Session reset and reconfigured for sticker: maquiagem")
            }
        }
    }
    
    private func handleImageDetected(_ imageAnchor: ARImageAnchor) {
        let stickerName = imageAnchor.referenceImage.name ?? "Unknown Sticker"
        print("🎯 Sticker detected: \(stickerName)")
        
        // Verificar se é o sticker correto e se ainda não foi detectado
        if stickerName == "Sticker_Maquiagem" && !hasDetectedMaquiagem {
            hasDetectedMaquiagem = true
            print("🎉 Maquiagem sticker detected successfully!")
            
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
        } else if stickerName != "Sticker_Maquiagem" {
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
            "Maquiagem Detectada!",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.05),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: UIColor.systemPink, isMetallic: false)
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
