//
//  LuzStickerPhase3ARContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

struct LuzStickerPhase3ARContainerView: UIViewRepresentable {
    let viewModel: StartGameViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        // Reset completo da sessão AR antes de configurar
        resetARSession(arView)
        
        coordinator.setupARView(arView)
        coordinator.viewModel = viewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> LuzStickerPhase3Coordinator {
        LuzStickerPhase3Coordinator(viewModel: viewModel)
    }
    
    private func resetARSession(_ arView: ARView) {
        print("🔄 Resetting AR Session for Phase 3 Luz Scanner...")
        
        // Pausar a sessão atual
        arView.session.pause()
        
        // Limpar todos os anchors existentes
        if let currentFrame = arView.session.currentFrame {
            for anchor in currentFrame.anchors {
                arView.session.remove(anchor: anchor)
                print("🗑️ Removed anchor: \(anchor)")
            }
        }
        
        // Aguardar um pouco antes de reconfigurar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.configureARSession(for: arView)
        }
    }
    
    private func configureARSession(for arView: ARView) {
        guard ARImageTrackingConfiguration.isSupported else {
            print("❌ Image tracking is not supported on this device")
            return
        }
        
        let configuration = ARImageTrackingConfiguration()
        
        // Configurar especificamente para o sticker "luz" da Fase 3
        // Usando o mesmo asset mas com configuração independente
        if let image = UIImage(named: "luz"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Luz_Phase3" // Nome único para Fase 3
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            print("✅ Phase 3 AR Session configured for sticker: luz")
            print("✅ Reference image name: \(referenceImage.name ?? "Unknown")")
            print("✅ Image size: \(cgImage.width) x \(cgImage.height)")
            
            // Executar a nova configuração
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            print("❌ Failed to load image: luz for Phase 3")
        }
    }
}
