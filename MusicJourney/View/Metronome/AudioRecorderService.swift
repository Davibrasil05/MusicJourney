//
//  AudioRecorderService.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//

import Foundation
import AVFoundation

class AudioRecorderService: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var startTime: Date?
    @Published var lastRecordingDuration: Double = 0.0
    
    @Published var isRecording = false
    @Published var lastRecordedAudioURL: URL?
    
    // MARK: - Estado do Player
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    
    private var timer: Timer?
    
    // O URL do áudio que está carregado no momento (para sabermos se devemos dar Resume ou começar do zero)
    @Published var currentlyPlayingURL: URL?

    // MARK: - Gravação
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Falha ao configurar a sessão de áudio")
        }
        
        let fileName = "gravacao_\(Date().timeIntervalSince1970).m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            startTime = Date()
            isRecording = true
        } catch {
            print("Não foi possível iniciar a gravação")
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        if let start = startTime {
            lastRecordingDuration = Date().timeIntervalSince(start)
        }
        lastRecordedAudioURL = audioRecorder?.url
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Reprodução (Player)
    func playAudio(url: URL) {
        // Se já está tocando e a URL é a mesma, só retoma de onde parou
        if currentlyPlayingURL == url && audioPlayer != nil {
            resumeAudio()
            return
        }
        
        stopAudio() // Para qualquer outra coisa que estiver tocando
        
        do {
            // Garante que o som sai no alto-falante principal
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
            currentlyPlayingURL = url
            duration = audioPlayer?.duration ?? 0.0
            
            startTimer()
        } catch {
            print("Erro ao tentar tocar o áudio: \(error)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func resumeAudio() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
        currentTime = 0.0
        currentlyPlayingURL = nil
        stopTimer()
    }
    
    func seek(to seconds: TimeInterval) {
        audioPlayer?.currentTime = seconds
        currentTime = seconds
    }
    
    func skipForward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = min(player.currentTime + seconds, player.duration)
        seek(to: newTime)
    }
    
    func skipBackward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = max(player.currentTime - seconds, 0)
        seek(to: newTime)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Opcional: Para sozinho quando a música chega ao final
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0.0
        stopTimer()
    }
}
