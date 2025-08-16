//
//  StartGameInstructionsModal.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameInstructionsModal: View {
    @Binding var isVisible: Bool
    let onAdvance: () -> Void
    
    var body: some View {
        ZStack {
            // Background Overlay
            BackgroundOverlayView(isVisible: $isVisible)
            
            // Modal Content
            ModalContentView(
                isVisible: $isVisible,
                onAdvance: onAdvance
            )
        }
    }
}

// MARK: - Background Overlay Component
private struct BackgroundOverlayView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isVisible = false
            }
    }
}

// MARK: - Modal Content Component
private struct ModalContentView: View {
    @Binding var isVisible: Bool
    let onAdvance: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HeaderView()
            
            // Instructions Text
            InstructionsTextView()
            
            // Action Button
            ActionButtonView(onAdvance: onAdvance)
        }
        .padding(32)
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(radius: 20)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
    }
}

// MARK: - Header Component
private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "rocket.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Rocket Detected!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Instructions Text Component
private struct InstructionsTextView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to the RodaRico Experience!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("You've successfully activated the rocket tracking system. This advanced AR technology will guide you through an incredible journey filled with challenges and discoveries.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("Prepare yourself for an adventure that will test your skills and unlock the secrets of the RodaRico universe.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
}

// MARK: - Action Button Component
private struct ActionButtonView: View {
    let onAdvance: () -> Void
    
    var body: some View {
        Button(action: onAdvance) {
            HStack {
                Text("Start Adventure")
                    .fontWeight(.semibold)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
    }
}

#Preview {
    StartGameInstructionsModal(
        isVisible: .constant(true),
        onAdvance: {}
    )
}

