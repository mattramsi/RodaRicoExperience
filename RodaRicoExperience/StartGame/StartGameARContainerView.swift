//
//  StartGameARContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

struct StartGameARContainerView: UIViewRepresentable {
    let viewModel: StartGameViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        coordinator.setupARView(arView)
        coordinator.configureARSession()
        
        // Conectar o callback de reset
        coordinator.onResetRequested = { [weak viewModel] in
            viewModel?.resetARSession()
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // No updates needed for this view
    }
    
    func makeCoordinator() -> StartGameARCoordinator {
        StartGameARCoordinator(viewModel: viewModel)
    }
    
    // Implementar cleanup quando a view for destruída
    static func dismantleUIView(_ uiView: ARView, coordinator: StartGameARCoordinator) {
        print("🧹 Dismantling AR View - cleaning up session")
        uiView.session.pause()
        
        // Limpar todos os anchors
        if let currentFrame = uiView.session.currentFrame {
            for anchor in currentFrame.anchors {
                uiView.session.remove(anchor: anchor)
                print("🗑️ Removed anchor during cleanup: \(anchor)")
            }
        }
    }
}

