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
    
    private let questions = [
        Question(
            text: "Qual é a cor da luz que você acabou de acender?",
            options: ["Vermelha", "Verde", "Amarela", "Azul"],
            correctAnswer: 2
        ),
        Question(
            text: "O que a luz representa na experiência RodaRico?",
            options: ["O início da jornada", "O fim da missão", "Uma pausa", "Um erro"],
            correctAnswer: 0
        ),
        Question(
            text: "Quantas missões você precisa completar no total?",
            options: ["1", "2", "3", "4"],
            correctAnswer: 2
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Progresso")
                        .font(.headline)
                        .foregroundColor(.primary)
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
            .padding(.top)
            
            Spacer()
            
            // Question Content
            VStack(spacing: 24) {
                Text("Pergunta \(currentQuestionIndex + 1) de \(questions.count)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
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
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.red)
            }
        }
        .alert("Resultado", isPresented: $showResult) {
            Button("Continuar") {
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
                Text("Parabéns! Você respondeu todas as perguntas corretamente! Iniciando Fase 2...")
            } else {
                Text("Você acertou \(correctAnswers) de 3 perguntas. Tente novamente!")
            }
        }
    }
    
    private func selectAnswer(_ selectedIndex: Int) {
        let question = questions[currentQuestionIndex]
        
        if selectedIndex == question.correctAnswer {
            correctAnswers += 1
            print("✅ Pergunta \(currentQuestionIndex + 1) da Fase 1 respondida corretamente!")
        } else {
            print("❌ Pergunta \(currentQuestionIndex + 1) da Fase 1 respondida incorretamente. Resposta correta: \(question.options[question.correctAnswer])")
        }
        
        // Avançar para próxima pergunta ou mostrar resultado
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }
}

#Preview {
    NavigationView {
        QuestionsPhase1View(viewModel: StartGameViewModel())
    }
}
