//
//  ARContainerFinalContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ARContainerFinalContainerView: UIViewRepresentable {
    let viewModel: StartGameViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        // Configurar sessão AR especial para a recompensa final
        configureFinalARSession(for: arView)
        
        coordinator.setupARView(arView)
        coordinator.viewModel = viewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> ARContainerFinalCoordinator {
        ARContainerFinalCoordinator(viewModel: viewModel)
    }
    
    private func configureFinalARSession(for arView: ARView) {
        guard ARImageTrackingConfiguration.isSupported else {
            print("❌ Image tracking is not supported on this device")
            return
        }
        
        print("🎯 Configurando sessão AR final especial...")
        
        let configuration = ARImageTrackingConfiguration()
        
        // Configurar para detectar múltiplos stickers como recompensa final
        var trackingImages: [ARReferenceImage] = []
        
        // Adicionar sticker "luz" para detecção final
        if let luzImage = UIImage(named: "luz"),
           let luzCGImage = luzImage.cgImage {
            let luzReference = ARReferenceImage(luzCGImage, orientation: .up, physicalWidth: 0.1)
            luzReference.name = "Final_Luz"
            trackingImages.append(luzReference)
        }
        
        // Adicionar sticker "maquiagem" para detecção final
        if let maquiagemImage = UIImage(named: "maquiagem"),
           let maquiagemCGImage = maquiagemImage.cgImage {
            let maquiagemReference = ARReferenceImage(maquiagemCGImage, orientation: .up, physicalWidth: 0.1)
            maquiagemReference.name = "Final_Maquiagem"
            trackingImages.append(maquiagemReference)
        }
        
        configuration.trackingImages = Set(trackingImages)
        configuration.maximumNumberOfTrackedImages = 2
        
        print("✅ Sessão AR final configurada com \(trackingImages.count) stickers")
        
        // Executar a configuração
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Adicionar elementos visuais especiais
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addFinalRewardElements(to: arView)
        }
    }
    
    private func addFinalRewardElements(to arView: ARView) {
        print("🎁 Adicionando elementos de recompensa final...")
        
        // Criar uma entidade de texto flutuante
        let textEntity = ModelEntity()
        let textMesh = MeshResource.generateText(
            "🎊 Parabéns! Jornada Completa! 🎊",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.08),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .orange, isMetallic: true)
        textEntity.model = ModelComponent(mesh: textMesh, materials: [material])
        textEntity.position = [0, 0.2, -0.5] // Posicionar na frente da câmera
        
        // Criar anchor para o texto
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        
        // Adicionar partículas de celebração
        addCelebrationParticles(to: arView)
        
        print("✅ Elementos de recompensa final adicionados com sucesso!")
    }
    
    private func addCelebrationParticles(to arView: ARView) {
        // Criar sistema de partículas simples para celebração
        var particleSystem = ParticleSystem()
        
        // Configurar partículas
        particleSystem.particleCount = 100
        particleSystem.particleSize = 0.02
        particleSystem.particleColor = .orange
        
        // Adicionar ao centro da cena
        let particleEntity = ModelEntity()
        particleEntity.position = [0, 0, 0]
        
        // Criar um AnchorEntity sem anchor específico para posicionar no mundo
        let worldAnchor = AnchorEntity()
        worldAnchor.addChild(particleEntity)
        arView.scene.addAnchor(worldAnchor)
    }
}

// MARK: - Particle System (Simplificado)
struct ParticleSystem {
    var particleCount: Int = 100
    var particleSize: Float = 0.02
    var particleColor: UIColor = .orange
    
    // Implementação simplificada para demonstração
    // Em um projeto real, você usaria RealityKit's ParticleSystem
}
