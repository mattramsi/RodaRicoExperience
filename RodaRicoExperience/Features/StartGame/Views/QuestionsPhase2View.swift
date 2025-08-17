//
//  QuestionsPhase2View.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct QuestionsPhase2View: View {
    @ObservedObject var viewModel: StartGameViewModel
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showResult = false
    @State private var showWrongAnswer = false
    
    private let questions = [
        Question(
            text: "Qual é o segundo componente que deve ser desarmado na bomba?",
            options: ["Sistema de ignição", "Detonador principal", "Cronômetro", "Sistema de segurança"],
            correctAnswer: 2
        ),
        Question(
            text: "Quantos componentes você precisa desarmar no total?",
            options: ["2", "3", "4", "5"],
            correctAnswer: 1
        ),
        Question(
            text: "O que acontece se o tempo acabar antes de desarmar a bomba?",
            options: ["A bomba explode", "A missão é cancelada", "Você ganha mais tempo", "A bomba se desarma sozinha"],
            correctAnswer: 0
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Timer da Missão
            MissionTimerView(
                timeRemaining: viewModel.timeRemaining,
                isTimerRunning: viewModel.isTimerRunning
            )
            
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("🔍 PROGRESSO DO DESARMA")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Spacer()
                    Text("\(correctAnswers)/3")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                ProgressView(value: Double(correctAnswers), total: 3.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Question Content
            VStack(spacing: 24) {
                Text("🚨 PERGUNTA \(currentQuestionIndex + 1) de \(questions.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text(questions[currentQuestionIndex].text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Answer Options
                VStack(spacing: 12) {
                    ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                        Button(action: {
                            selectAnswer(index)
                        }) {
                            HStack {
                                Text(questions[currentQuestionIndex].options[index])
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("🚨 ABORTAR MISSÃO") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.red)
                .fontWeight(.bold)
            }
        }
        .alert("✅ COMPONENTE DESARMADO!", isPresented: $showResult) {
            Button("CONTINUAR DESARMA") {
                if correctAnswers == 3 {
                    print("🎉 Todas as perguntas da Fase 2 foram respondidas com sucesso!")
                    print("📊 Respostas corretas: \(correctAnswers)/3")
                    print("🔄 Chamando completePhase2()...")
                    viewModel.completePhase2()
                    print("✅ Phase 2 completada, chamando navigateToPhase3Intro()...")
                    viewModel.navigateToPhase3Intro()
                    print("🚀 Navegação para Phase 3 solicitada!")
                } else {
                    print("❌ Apenas \(correctAnswers)/3 respostas corretas. Resetando...")
                    // Reset para tentar novamente
                    currentQuestionIndex = 0
                    correctAnswers = 0
                }
            }
        } message: {
            if correctAnswers == 3 {
                Text("Parabéns! Você desarmou o segundo componente da bomba! Continue para o último!")
            } else {
                Text("Você acertou \(correctAnswers) de 3 perguntas. Tente novamente!")
            }
        }
        .alert("❌ RESPOSTA INCORRETA!", isPresented: $showWrongAnswer) {
            Button("CONTINUAR") {
                // Continua para próxima pergunta
            }
        } message: {
            Text("Você perdeu 30 segundos do seu tempo! Tempo restante: \(formatTime(viewModel.timeRemaining))")
        }
    }
    
    private func selectAnswer(_ selectedIndex: Int) {
        let question = questions[currentQuestionIndex]
        
        if selectedIndex == question.correctAnswer {
            correctAnswers += 1
            print("✅ Pergunta \(currentQuestionIndex + 1) da Fase 2 respondida corretamente!")
        } else {
            print("❌ Pergunta \(currentQuestionIndex + 1) da Fase 2 respondida incorretamente. Resposta correta: \(question.options[question.correctAnswer])")
            viewModel.penaltyTime() // Aplica penalidade de 30 segundos
            showWrongAnswer = true
        }
        
        // Avançar para próxima pergunta ou mostrar resultado
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    NavigationView {
        QuestionsPhase2View(viewModel: StartGameViewModel())
    }
}
