//
//  ContentView.swift
//  Steps
//
//  Created by Nikita Pekurin on 6.01.21.
//

import SwiftUI

private let appGroupKey = "group.com.pnikita.Steps"

struct ContentView: View {
    
    @State private var stepsValue: Double = 0.0
    @State private var dailyGoal: String = ""
    
    @AppStorage("dailyGoal", store: UserDefaults(suiteName: appGroupKey))
    private var desiredValue: Double = 0.0
    
    
    var body: some View {
        VStack {
            Image("Sneaker")
            
            ProgressBar(progress: self.$stepsValue,
                        target: self.$desiredValue)
                .frame(width: 150.0, height: 150.0)
                .padding(40.0)
                        
            Divider()
            
            HStack {
                Text("Set your daily goal:")
                    .font(.body)
                    .foregroundColor(.blue)
                
                TextField("goal", text: $dailyGoal)
                    .fixedSize()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: dailyGoal, perform: { value in
                        desiredValue = Double(dailyGoal) ?? 0.0
                    })
            }
            
            Divider()

        }
        .onAppear {
            self.dailyGoal = String(Int(self.desiredValue))
            HKHelper.shared?.requestAuthorization { (hasAccess) in
                guard hasAccess == true else { return }
                self.getSteps()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    func getSteps() {
        // TODO: show onboarding
        guard HKHelper.shared?.hasAccess == true else {
            return
        }
        
        HKHelper.shared?.getStepsCount { (query, statistics, error) in
            DispatchQueue.main.async {
                guard let statistics = statistics else {
                    self.stepsValue = 0.0
                    return
                }
                self.stepsValue = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
