//
//  QuestionsPhase1View.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct QuestionsPhase1View: View {
    @ObservedObject var viewModel: StartGameViewModel
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showResult = false
    @State private var showWrongAnswer = false
    
    private let questions = [
        Question(
            text: "Qual é a cor do fio que deve ser cortado primeiro para desarmar a bomba?",
            options: ["Vermelho", "Verde", "Amarelo", "Azul"],
            correctAnswer: 1
        ),
        Question(
            text: "Quantos segundos você perde ao responder incorretamente?",
            options: ["15 segundos", "20 segundos", "30 segundos", "45 segundos"],
            correctAnswer: 2
        ),
        Question(
            text: "Qual é o tempo limite para desarmar completamente a bomba?",
            options: ["5 minutos", "8 minutos", "10 minutos", "15 minutos"],
            correctAnswer: 2
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
                    print("🎉 Todas as perguntas da Fase 1 foram respondidas com sucesso! Iniciando Fase 2...")
                    viewModel.completePhase1()
                    viewModel.navigateToMaquiagemScanner()
                } else {
                    // Reset para tentar novamente
                    currentQuestionIndex = 0
                    correctAnswers = 0
                }
            }
        } message: {
            if correctAnswers == 3 {
                Text("Parabéns! Você desarmou o primeiro componente da bomba! Continue para o próximo!")
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
            print("✅ Pergunta \(currentQuestionIndex + 1) da Fase 1 respondida corretamente!")
        } else {
            print("❌ Pergunta \(currentQuestionIndex + 1) da Fase 1 respondida incorretamente. Resposta correta: \(question.options[question.correctAnswer])")
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
        QuestionsPhase1View(viewModel: StartGameViewModel())
    }
}
