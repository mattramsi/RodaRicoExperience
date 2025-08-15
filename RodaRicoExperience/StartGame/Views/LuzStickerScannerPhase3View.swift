//
//  LuzStickerScannerPhase3View.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerScannerPhase3View: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container
            LuzStickerPhase3ARContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            LuzStickerPhase3OverlayView(viewModel: viewModel)
            
            // Success Modal
            if viewModel.isSuccessVisible {
                LuzStickerPhase3SuccessView(
                    isVisible: $viewModel.isSuccessVisible,
                    onDismiss: {
                        viewModel.navigateToPhase3Questions()
                    }
                )
            }
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
        LuzStickerScannerPhase3View(viewModel: StartGameViewModel())
    }
}
