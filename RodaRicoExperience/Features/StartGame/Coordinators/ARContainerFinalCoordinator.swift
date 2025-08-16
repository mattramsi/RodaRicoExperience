//
//  ARContainerFinalCoordinator.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import ARKit
import RealityKit
import SwiftUI

final class ARContainerFinalCoordinator: NSObject, ARSessionDelegate {
    var viewModel: StartGameViewModel
    private weak var arView: ARView?
    private var detectedStickers: Set<String> = []
    
    init(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
        print("🎯 AR Container Final Coordinator setup complete")
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                let stickerName = imageAnchor.referenceImage.name ?? "Unknown"
                print("🎯 Final AR: New sticker detected: \(stickerName)")
                
                detectedStickers.insert(stickerName)
                handleFinalStickerDetection(imageAnchor)
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
                        print("👁️ Final AR: Tracking: \(anchorName)")
                    } else {
                        print("👁️ Final AR: Lost tracking: \(anchorName)")
                    }
                }
            }
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                let stickerName = imageAnchor.referenceImage.name ?? "Unknown"
                print("🗑️ Final AR: Sticker removed: \(stickerName)")
                detectedStickers.remove(stickerName)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("❌ Final AR: Session failed: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("⚠️ Final AR: Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("✅ Final AR: Session interruption ended")
        // Reconfigurar após interrupção
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reconfigureFinalSession()
        }
    }
    
    private func reconfigureFinalSession() {
        guard let arView = arView else { return }
        print("🔄 Final AR: Reconfiguring session after interruption...")
        
        // Pausar e limpar
        arView.session.pause()
        
        // Reconfigurar com os stickers finais
        let configuration = ARImageTrackingConfiguration()
        var trackingImages: [ARReferenceImage] = []
        
        if let luzImage = UIImage(named: "luz"),
           let luzCGImage = luzImage.cgImage {
            let luzReference = ARReferenceImage(luzCGImage, orientation: .up, physicalWidth: 0.1)
            luzReference.name = "Final_Luz"
            trackingImages.append(luzReference)
        }
        
        if let maquiagemImage = UIImage(named: "maquiagem"),
           let maquiagemCGImage = maquiagemImage.cgImage {
            let maquiagemReference = ARReferenceImage(maquiagemCGImage, orientation: .up, physicalWidth: 0.1)
            maquiagemReference.name = "Final_Maquiagem"
            trackingImages.append(maquiagemReference)
        }
        
        configuration.trackingImages = Set(trackingImages)
        configuration.maximumNumberOfTrackedImages = 2
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("✅ Final AR: Session reconfigured")
    }
    
    private func handleFinalStickerDetection(_ imageAnchor: ARImageAnchor) {
        let stickerName = imageAnchor.referenceImage.name ?? "Unknown"
        print("🎉 Final AR: Sticker detected: \(stickerName)")
        
        // Adicionar efeito visual especial para cada sticker
        addSpecialEffect(for: imageAnchor, stickerName: stickerName)
        
        // Mostrar mensagem de celebração
        showCelebrationMessage(for: stickerName)
        
        // Remover anchor após alguns segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.arView?.session.remove(anchor: imageAnchor)
        }
    }
    
    private func addSpecialEffect(for imageAnchor: ARImageAnchor, stickerName: String) {
        guard let arView = arView else { return }
        
        // Criar efeito visual baseado no sticker
        let effectEntity = ModelEntity()
        
        switch stickerName {
        case "Final_Luz":
            // Efeito de luz para o sticker "luz"
            let lightMesh = MeshResource.generateBox(size: 0.1)
            let lightMaterial = SimpleMaterial(color: .yellow, isMetallic: true)
            effectEntity.model = ModelComponent(mesh: lightMesh, materials: [lightMaterial])
            effectEntity.position = [0, 0.1, 0]
            
        case "Final_Maquiagem":
            // Efeito de maquiagem para o sticker "maquiagem"
            let makeupMesh = MeshResource.generateSphere(radius: 0.05)
            let makeupMaterial = SimpleMaterial(color: .systemPink, isMetallic: true)
            effectEntity.model = ModelComponent(mesh: makeupMesh, materials: [makeupMaterial])
            effectEntity.position = [0, 0.1, 0]
            
        default:
            return
        }
        
        // Adicionar à cena
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(effectEntity)
        arView.scene.addAnchor(anchorEntity)
        
        // Remover após alguns segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            arView.scene.removeAnchor(anchorEntity)
        }
    }
    
    private func showCelebrationMessage(for stickerName: String) {
        guard let arView = arView else { return }
        
        let message: String
        switch stickerName {
        case "Final_Luz":
            message = "🌟 Luz da Transformação!"
        case "Final_Maquiagem":
            message = "💄 Beleza Revelada!"
        default:
            message = "🎊 Sticker Detectado!"
        }
        
        // Criar mensagem de celebração
        let textEntity = ModelEntity()
        let textMesh = MeshResource.generateText(
            message,
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.06),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .orange, isMetallic: true)
        textEntity.model = ModelComponent(mesh: textMesh, materials: [material])
        textEntity.position = [0, 0.15, 0]
        
        // Adicionar à cena
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        
        // Remover após alguns segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            arView.scene.removeAnchor(anchorEntity)
        }
    }
}
