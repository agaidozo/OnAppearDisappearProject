//
//  ContentView.swift
//  OnAppearDisappearProject
//
//  Created by Obde Willy on 20/03/23.
//

import SwiftUI

class SummaryViewModel: ObservableObject {
    @Published var sliderValue: Double = 0.0
    @Published var isDarkMode: Bool = false
    
    var summaryText: String {
        let colorName = isDarkMode ? "preto" : "branco"
        return "Valor do Slider: \(Int(sliderValue))\nModo de fundo: \(colorName)"
    }
}

struct ContentView: View {
    @StateObject private var summaryViewModel = SummaryViewModel()
    @State private var isSummaryShowing = false
    
    var body: some View {
        ZStack {
            Color(summaryViewModel.isDarkMode ? .black : .white)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Valor do Slider: \(Int(summaryViewModel.sliderValue))")
                
                Slider(value: $summaryViewModel.sliderValue, in: 0...100, step: 1)
                
                TextField("Valor do Slider", value: $summaryViewModel.sliderValue, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                
                Toggle("Modo de fundo", isOn: $summaryViewModel.isDarkMode)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .padding()
                
                Button(action: {
                    isSummaryShowing.toggle()
                }, label: {
                    Text("Exibir resumo")
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .cornerRadius(10)
                })
                .sheet(isPresented: $isSummaryShowing, content: {
                    SummaryView()
                        .environmentObject(summaryViewModel)
                })
                Spacer()
            }
            .padding()
        }
        .environmentObject(summaryViewModel)
    }
}

struct SummaryView: View {
    @EnvironmentObject var summaryViewModel: SummaryViewModel
    
    var body: some View {
        VStack {
            Text(summaryViewModel.summaryText)
                .padding()
            Button(action: {
                summaryViewModel.sliderValue = 0.0
                summaryViewModel.isDarkMode = false
            }, label: {
                Text("Resetar valores")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            Spacer()
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
