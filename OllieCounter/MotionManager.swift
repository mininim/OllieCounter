//
//  MotionManager.swift
//  OllieCounter
//
//  Created by Eric Lee on 2023/04/19.
//
import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var updateTimer: Timer?
    private var threshold: Double?
    private var onDetect: (() -> Void)?
    
    var isDetecting: Bool {
        updateTimer != nil
    }
    
    func startUpdates(threshold: Double, onDetect: (() -> Void)?) {
        self.threshold = threshold
        self.onDetect = onDetect
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let acceleration = self.motionManager.accelerometerData?.acceleration else { return }
            let accelerationMagnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
            if accelerationMagnitude > threshold {
                onDetect?()
                self.stopUpdates()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.startUpdates(threshold: threshold, onDetect: onDetect)
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        updateTimer?.invalidate()
        updateTimer = nil
        threshold = nil
        onDetect = nil
    }
}
