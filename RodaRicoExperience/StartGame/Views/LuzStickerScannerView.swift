//
//  LuzStickerScannerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerScannerView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container
            LuzStickerARContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            LuzStickerOverlayView(viewModel: viewModel)
            
            // Success Modal
            if viewModel.isSuccessVisible {
                LuzStickerSuccessView(
                    isVisible: $viewModel.isSuccessVisible,
                    onDismiss: {
                        viewModel.navigateToPhase1Questions()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar ao AR") {
                    viewModel.goBackToAR()
                }
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    NavigationView {
        LuzStickerScannerView(viewModel: StartGameViewModel())
    }
}
