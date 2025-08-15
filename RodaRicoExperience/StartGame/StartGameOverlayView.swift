//
//  StartGameOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameOverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            // Status Indicator
            HStack {
                Spacer()
                StatusIndicatorView(isTrackingActive: viewModel.isTrackingActive)
                    .padding()
            }
            
            Spacer()
            
            // Instructions
            InstructionsView(detectionCount: viewModel.detectionCount)
                .padding()
            
            // Reset Button
            HStack {
                Spacer()
                Button("Reset AR") {
                    viewModel.resetARSession()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Status Indicator Component
private struct StatusIndicatorView: View {
    let isTrackingActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(isTrackingActive ? Color.green : Color.red)
                .frame(width: 20, height: 20)
            
            Text(isTrackingActive ? "Tracking" : "Searching")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
    }
}

// MARK: - Instructions Component
private struct InstructionsView: View {
    let detectionCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Point your camera at the rocket")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("The game will start automatically")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text("Detections: \(detectionCount)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 8)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
    }
}

#Preview {
    StartGameOverlayView(viewModel: StartGameViewModel())
        .background(Color.black)
}

