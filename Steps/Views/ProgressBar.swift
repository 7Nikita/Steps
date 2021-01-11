//
//  StepView.swift
//  Steps
//
//  Created by Nikita Pekurin on 6.01.21.
//

import SwiftUI
import Foundation

struct ProgressBar: View {
    @Binding var progress: Double
    @Binding var target: Double
    
    let progressColor: Color = .red
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(progressColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress / self.target, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%0.f", self.progress))
                .font(.title2)
                .bold()
        }
    }
}
