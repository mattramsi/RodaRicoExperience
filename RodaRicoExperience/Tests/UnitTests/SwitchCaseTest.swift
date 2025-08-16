//
//  SwitchCaseTest.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//
//  Arquivo de teste simples para verificar se o switch case está funcionando

import SwiftUI

struct SwitchCaseTest {
    
    static func testSwitchCase() {
        print("🧪 Testing Switch Case...")
        
        let testState: StartGameViewState = .phase3Intro
        
        switch testState {
        case .initial:
            print("✅ Initial case")
        case .startGame:
            print("✅ AR View case")
        case .luzScanner:
            print("✅ Luz Scanner case")
        case .phase1Questions:
            print("✅ Phase 1 Questions case")
        case .maquiagemScanner:
            print("✅ Maquiagem Scanner case")
        case .phase2Questions:
            print("✅ Phase 2 Questions case")
        case .phase3Intro:
            print("✅ Phase 3 Intro case")
        case .luzScannerPhase3:
            print("✅ Luz Scanner Phase 3 case")
        case .phase3Questions:
            print("✅ Phase 3 Questions case")
        case .gameComplete:
            print("✅ Game Complete case")
        case .arContainerFinal:
            print("✅ AR Container Final case")
        case .arExperienceFinal:
            print("✅ AR Experience Final case")
        }
        
        print("🎉 Switch case test passed!")
    }
}

#Preview {
    VStack {
        Text("Switch Case Test")
            .font(.title)
            .padding()
        
        Button("Test Switch") {
            SwitchCaseTest.testSwitchCase()
        }
        .padding()
        .background(Color.purple)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
