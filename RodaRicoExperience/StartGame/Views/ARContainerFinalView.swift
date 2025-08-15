//
//  ARContainerFinalView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct ARContainerFinalView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container Final
            ARContainerFinalContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            ARContainerFinalOverlayView(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    NavigationView {
        ARContainerFinalView(viewModel: StartGameViewModel())
    }
}
