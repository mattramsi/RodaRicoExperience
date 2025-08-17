//
//  MissionTimerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct MissionTimerView: View {
    let timeRemaining: TimeInterval
    let isTimerRunning: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.red)
                    .font(.title2)
                
                Text("TEMPO RESTANTE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Spacer()
            }
            
            HStack {
                Text(formatTime(timeRemaining))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(timeRemaining < 120 ? .red : .primary)
                    .animation(.easeInOut(duration: 0.3), value: timeRemaining)
                
                Spacer()
                
                if isTimerRunning {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Image(systemName: "pause.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
            }
            
            // Barra de progresso do tempo
            ProgressView(value: timeRemaining, total: 600)
                .progressViewStyle(LinearProgressViewStyle(tint: timeRemaining < 120 ? .red : .green))
                .scaleEffect(x: 1, y: 3, anchor: .center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(timeRemaining < 120 ? Color.red : Color.green, lineWidth: 2)
        )
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    VStack(spacing: 20) {
        MissionTimerView(timeRemaining: 600, isTimerRunning: true)
        MissionTimerView(timeRemaining: 120, isTimerRunning: true)
        MissionTimerView(timeRemaining: 30, isTimerRunning: true)
    }
    .padding()
}
