//
//  MaquiagemStickerScannerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct MaquiagemStickerScannerView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container
            MaquiagemStickerARContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            MaquiagemStickerOverlayView(viewModel: viewModel)
            
            // Success Modal
//            if viewModel.isSuccessVisible {
               
//            }
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
        MaquiagemStickerScannerView(viewModel: StartGameViewModel())
    }
}
