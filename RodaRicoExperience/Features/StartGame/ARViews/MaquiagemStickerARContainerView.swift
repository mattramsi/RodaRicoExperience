//
//  MaquiagemStickerARContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

struct MaquiagemStickerARContainerView: UIViewRepresentable {
    let viewModel: StartGameViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        // Configurar a sessão AR de forma mais simples e estável
        configureARSession(for: arView)
        
        coordinator.setupARView(arView)
        coordinator.viewModel = viewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> MaquiagemStickerCoordinator {
        MaquiagemStickerCoordinator(viewModel: viewModel)
    }
    
    private func configureARSession(for arView: ARView) {
        guard ARImageTrackingConfiguration.isSupported else {
            print("❌ Image tracking is not supported on this device")
            return
        }
        
        print("🔧 Starting AR session configuration for Maquiagem sticker...")
        
        let configuration = ARImageTrackingConfiguration()
        
        // Configurar especificamente para o sticker "maquiagem"
        if let image = UIImage(named: "maquiagem"),
           let cgImage = image.cgImage {
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.1)
            referenceImage.name = "Sticker_Maquiagem"
            configuration.trackingImages = [referenceImage]
            configuration.maximumNumberOfTrackedImages = 1
            
            print("✅ AR Session configured for sticker: maquiagem")
            print("✅ Reference image name: \(referenceImage.name ?? "Unknown")")
            print("✅ Image size: \(cgImage.width) x \(cgImage.height)")
            print("✅ Configuration tracking images count: \(configuration.trackingImages.count)")
            
            // Verificar se a configuração está correta
            guard configuration.trackingImages.count > 0 else {
                print("❌ Configuration has no tracking images!")
                return
            }
            
            // Executar a configuração sem reset agressivo
            arView.session.run(configuration, options: [])
            print("✅ AR session started successfully")
            
            // Verificar o status da sessão após um breve delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let sessionState = arView.session.currentFrame?.camera.trackingState
                let statusString = self.trackingStateToString(sessionState)
                print("📱 Session status after 1s: \(statusString)")
            }
        } else {
            print("❌ Failed to load image: maquiagem")
            print("❌ Available images in bundle:")
            if let bundle = Bundle.main.resourcePath {
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: bundle)
                    let imageFiles = files.filter { $0.contains("maquiagem") || $0.contains(".png") || $0.contains(".jpg") || $0.contains(".jpeg") }
                    print("📁 Found image files: \(imageFiles)")
                } catch {
                    print("❌ Error listing bundle contents: \(error)")
                }
            }
        }
    }
    
    private func trackingStateToString(_ state: ARCamera.TrackingState?) -> String {
        guard let state = state else { return "Unknown" }
        
        switch state {
        case .notAvailable:
            return "Not Available"
        case .limited(let reason):
            switch reason {
            case .initializing:
                return "Initializing"
            case .excessiveMotion:
                return "Excessive Motion"
            case .insufficientFeatures:
                return "Insufficient Features"
            case .relocalizing:
                return "Relocalizing"
            @unknown default:
                return "Limited (Unknown)"
            }
        case .normal:
            return "Normal"
        }
    }
}
