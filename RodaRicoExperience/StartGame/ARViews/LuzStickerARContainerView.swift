//
//  LuzStickerARContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

struct LuzStickerARContainerView: UIViewRepresentable {
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
    
    func makeCoordinator() -> LuzStickerCoordinator {
        LuzStickerCoordinator(viewModel: viewModel)
    }
    
    private func resetARSession(_ arView: ARView) {
        print("🔄 Resetting AR Session completely...")
        
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
        
        // Configurar especificamente para o sticker "luz"
        if let image = UIImage(named: "luz"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Luz"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            print("✅ AR Session configured for sticker: luz")
            print("✅ Reference image name: \(referenceImage.name ?? "Unknown")")
            print("✅ Image size: \(cgImage.width) x \(cgImage.height)")
            
            // Executar a nova configuração
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            print("❌ Failed to load image: luz")
            print("❌ Available images in bundle:")
            if let bundle = Bundle.main.resourcePath {
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: bundle)
                    let imageFiles = files.filter { $0.contains("luz") || $0.contains(".png") || $0.contains(".jpg") || $0.contains(".jpeg") }
                    print("📁 Found image files: \(imageFiles)")
                } catch {
                    print("❌ Error listing bundle contents: \(error)")
                }
            }
        }
    }
}
