//
//  Phase3IntroView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct Phase3IntroView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Phase 3 Icon
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.orange)
                .shadow(radius: 10)
            
            // Introduction Text
            VStack(spacing: 20) {
                Text("🌟 Fase 3 - A Jornada Final 🌟")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Parabéns por chegar até aqui!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Você já completou duas fases incríveis da experiência RodaRico. Agora é hora da fase final!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Phase Summary
            VStack(spacing: 16) {
                Text("Resumo das Fases Completadas")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Fase 1: Luz Acesa")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.pink)
                        Text("Fase 2: Maquiagem Aplicada")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            }
            
            // Phase 3 Description
            VStack(spacing: 16) {
                Text("Experiência AR Final - Recompensa!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                VStack(spacing: 12) {
                    HStack(alignment: .top) {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Primeiro, responda 3 perguntas finais sobre sua jornada")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.blue)
                        Text("Depois, veja sua recompensa AR especial")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "key.fill")
                            .foregroundColor(.orange)
                        Text("Por fim, receba uma chave mágica para abrir um baú de tesouro")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "hand.draw.fill")
                            .foregroundColor(.orange)
                        Text("Arraste a chave até o baú para abri-lo")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "number.circle.fill")
                            .foregroundColor(.orange)
                        Text("Quando o baú abrir, você receberá um código de 6 dígitos")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text("Este código é sua recompensa final pela jornada completa!")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(15)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button("Responder Questões da Fase 3") {
                    viewModel.navigateToPhase3Questions()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.green)
                .font(.headline)
                .shadow(radius: 5)
                
                Button("Ver Recompensa AR") {
                    viewModel.navigateToARContainerFinal()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
                .font(.headline)
                .shadow(radius: 5)
            }
            
            // Back Button
            Button("Voltar à Fase 2") {
                viewModel.goBackToPreviousView()
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .font(.headline)
            
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    NavigationView {
        Phase3IntroView(viewModel: StartGameViewModel())
    }
}
