//
//  ARContainerFinalView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

// MARK: - Main View
struct ARContainerFinalView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container
            ARContainerFinalContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            ARContainerFinalOverlayView(viewModel: viewModel)
        }
        .navigationTitle("Recompensa AR Final")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ARContainerFinalView(viewModel: StartGameViewModel())
    }
}

