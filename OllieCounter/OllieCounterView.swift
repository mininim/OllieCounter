//
//  OllieCounterView.swift
//  OllieCounter
//
//  Created by Eric Lee on 2023/04/19.
//

import SwiftUI

struct OllieCounterView: View {
    // MARK: - Properties
    @State private var ollieCount = 0
    @State private var isDetecting = false
    @StateObject private var motionManager = MotionManager()
    @State private var showCheerUp = false
    @State private var isShowingInstructions = false // Instructions sheet 제어
    let accelerationThreshold = 1.5 // Ollie 감지를 위한 가속도 임계값
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button {
                    self.isShowingInstructions.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
                
            }
            
            Spacer()
            Text("Ollie Count: \(ollieCount)")
                .font(.title)
            Spacer()
            
            HStack {
                Spacer()
                ControlButtonView(title: isDetecting ? "Cheer Up" : "Reset", bgColor: Color.gray, textColor: Color.white,opacity: isDetecting ? 0.8 : 0.4) {
                    if isDetecting{
                        showCheerUp = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showCheerUp = false
                        }
                    }else{
                        ollieCount = 0
                    }
                }
                .frame(width: 100, height: 100)
                
                Spacer()
                
                ControlButtonView(title: isDetecting ? "Pause" : "Start", bgColor: isDetecting ?.red : .green, textColor: isDetecting ? .red : .green, opacity: 0.4) {
                    isDetecting.toggle()
                    if isDetecting {
                        motionManager.startUpdates(threshold: accelerationThreshold) { ollieCount += 1 }
                    } else {
                        motionManager.stopUpdates()
                    }
                }
                .frame(width: 100, height: 100)
                Spacer()
                
            }
            .padding()
            
            Spacer()
            
        }
        .overlay(
            showCheerUp ?
            Text("👍👏😀")
                .font(.system(size: 80))
                .transition(.scale)
            : nil
        )
        .sheet(isPresented: $isShowingInstructions) {
            VStack {
                Image("OllieFicto")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)

                Text("How to Use Ollie Counter")
                    .font(.title)
                    .padding()
                Text("1. Hold your device in your hand or put it in your bag or pocket.\n2. Practice your Ollie!\n3. The count will increase if the Ollie is detected.\n4. You can reset the count using the reset button.")
                    .padding()
                
                Button(action: {
                    self.isShowingInstructions.toggle()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct OllieCounterView_Previews: PreviewProvider {
    static var previews: some View {
        OllieCounterView()
    }
}
