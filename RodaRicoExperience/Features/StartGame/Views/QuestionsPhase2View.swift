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
    
    private let questions = [
        Question(
            text: "Qual é a cor principal da maquiagem?",
            options: ["Azul", "Verde", "Rosa", "Amarelo"],
            correctAnswer: 2
        ),
        Question(
            text: "O que a maquiagem representa na experiência?",
            options: ["Beleza e transformação", "Limpeza", "Exercício", "Alimentação"],
            correctAnswer: 0
        ),
        Question(
            text: "Quantas fases você já completou até agora?",
            options: ["1", "2", "3", "4"],
            correctAnswer: 1
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
                        .foregroundColor(.pink)
                }
                
                ProgressView(value: Double(correctAnswers), total: 3.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pink))
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
                Text("Parabéns! Você respondeu todas as perguntas corretamente! Iniciando Fase 3...")
            } else {
                Text("Você acertou \(correctAnswers) de 3 perguntas. Tente novamente!")
            }
        }
    }
    
    private func selectAnswer(_ selectedIndex: Int) {
        let question = questions[currentQuestionIndex]
        
        if selectedIndex == question.correctAnswer {
            correctAnswers += 1
            print("✅ Pergunta \(currentQuestionIndex + 1) da Fase 2 respondida corretamente!")
        } else {
            print("❌ Pergunta \(currentQuestionIndex + 1) da Fase 2 respondida incorretamente. Resposta correta: \(question.options[question.correctAnswer])")
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
        QuestionsPhase2View(viewModel: StartGameViewModel())
    }
}
