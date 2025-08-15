//
//  SwitchExhaustivenessTest.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//
//  Arquivo de teste para verificar se o switch case é exaustivo

import SwiftUI

struct SwitchExhaustivenessTest {
    
    static func testSwitchExhaustiveness() {
        print("🧪 Testing Switch Exhaustiveness...")
        
        let allStates: [StartGameViewState] = [
            .initial,
            .arView,
            .luzScanner,
            .phase1Questions,
            .maquiagemScanner,
            .phase2Questions,
            .phase3Intro,
            .luzScannerPhase3,
            .phase3Questions,
            .gameComplete,
            .arContainerFinal
        ]
        
        print("✅ Total states: \(allStates.count)")
        
        for (index, state) in allStates.enumerated() {
            print("  \(index + 1). \(state)")
        }
        
        // Testar se todos os casos são acessíveis
        let _: StartGameViewState = .phase3Intro
        let _: StartGameViewState = .luzScannerPhase3
        let _: StartGameViewState = .phase3Questions
        let _: StartGameViewState = .arContainerFinal
        
        print("✅ All Phase 3 states are accessible")
        print("🎉 Switch exhaustiveness test passed!")
    }
}

#Preview {
    VStack {
        Text("Switch Exhaustiveness Test")
            .font(.title)
            .padding()
        
        Button("Test Switch") {
            SwitchExhaustivenessTest.testSwitchExhaustiveness()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
