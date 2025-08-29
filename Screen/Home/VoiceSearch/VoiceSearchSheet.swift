//
//  VoiceSearchSheet.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI
import Speech

struct VoiceSearchSheet: View {
    @ObservedObject var recognizer = SpeechRecognizer()
    @Environment(\.dismiss) var dismiss
    @State private var showingPermissionAlert = false

    var onResult: (String) -> Void
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 40) {

            VStack(spacing: 20) {
                Text("Recipe")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Say something like:")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("•")
                            .foregroundColor(.white)
                        Text("Cuisine")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Text("•")
                            .foregroundColor(.white)
                        Text("Ingredients")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Text("•")
                            .foregroundColor(.white)
                        Text("Recipe")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .font(.body)
            }
            
            Spacer()
            
            ZStack {

                Circle()
                    .fill(Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.3))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.5))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(recognizer.isListening ? Color(red: 0.2, green: 0.8, blue: 0.6) : Color(red: 0.2, green: 0.8, blue: 0.6).opacity(0.8))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "mic.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                    )
                    .scaleEffect(recognizer.isListening ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: recognizer.isListening)
                
                if recognizer.isListening {
                    Circle()
                        .stroke(Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.3), lineWidth: 2)
                        .frame(width: 100, height: 100)
                        .scaleEffect(recognizer.isListening ? 1.5 : 1.0)
                        .opacity(recognizer.isListening ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: recognizer.isListening)
                    
                    Circle()
                        .stroke(Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.5), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(recognizer.isListening ? 1.3 : 1.0)
                        .opacity(recognizer.isListening ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false), value: recognizer.isListening)
                }
            }
            .onTapGesture {
                handleMicrophoneTap()
            }
            
            VStack(spacing: 10) {
                if recognizer.isListening {
                    Text("Listening...")
                        .font(.body)
                        .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.6))
                        .fontWeight(.medium)
                }
                
                if !recognizer.transcript.isEmpty {
                    VStack(spacing: 5) {
                        Text("You said:")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text("\"\(recognizer.transcript)\"")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
            
            Button(action: {
                recognizer.stopRecording()
                onDismiss?()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.25))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            recognizer.requestAuthorization { granted in
                if !granted {
                    showingPermissionAlert = true
                }
            }
        }
        .alert("Microphone Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) {
                onDismiss?()
            }
        } message: {
            Text("Please enable microphone access in Settings to use voice search.")
        }
    }
    
    private func handleMicrophoneTap() {
        if recognizer.isListening {
            recognizer.stopRecording()
            if !recognizer.transcript.isEmpty {
                onResult(recognizer.transcript)
                onDismiss?()
            }
        } else {
            recognizer.startRecording()
        }
    }
}
