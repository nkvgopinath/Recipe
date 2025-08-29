//
//  SpeechRecognizer.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import Foundation
import Speech
import AVFoundation

final class SpeechRecognizer: NSObject, ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var transcript: String = ""
    @Published var isListening: Bool = false
    @Published var errorMessage: String = ""
    @Published var hasPermission: Bool = false
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.hasPermission = status == .authorized
                switch status {
                case .authorized:
                    self?.errorMessage = ""
                case .denied:
                    self?.errorMessage = "Speech recognition access denied"
                case .restricted:
                    self?.errorMessage = "Speech recognition is restricted"
                case .notDetermined:
                    self?.errorMessage = "Speech recognition permission not determined"
                @unknown default:
                    self?.errorMessage = "Unknown permission status"
                }
                completion(status == .authorized)
            }
        }
    }
    
    func startRecording() {
        stopRecording() // ensure old session is cleared
        
        guard hasPermission else {
            requestAuthorization { [weak self] granted in
                if granted {
                    self?.startRecording()
                }
            }
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask?.cancel()
            recognitionTask = nil
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        self?.transcript = result.bestTranscription.formattedString
                    }
                }
                
                if error != nil || (result?.isFinal ?? false) {
                    self?.stopRecording()
                }
            }
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0,
                                 bufferSize: 1024,
                                 format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.isListening = true
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Speech recognition error: \(error.localizedDescription)"
                self.isListening = false
            }
            print(" error: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
}

