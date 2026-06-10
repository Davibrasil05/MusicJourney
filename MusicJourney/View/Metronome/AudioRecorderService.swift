//
//  AudioRecorderService.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//

import Foundation
import AVFoundation

class AudioRecorderService: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var startTime: Date?
    @Published var lastRecordingDuration: Double = 0.0
    
    // Variável que avisa a Tela se está gravando ou não
    @Published var isRecording = false
    
    // Variável para a Tela saber onde o arquivo foi salvo no final
    @Published var lastRecordedAudioURL: URL?
    
    // MARK: - Novas Variáveis para o Player
    @Published var recordings: [URL] = []
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    
    // MARK: - Novas Funções
    func fetchRecordings() {
        let directory = getDocumentsDirectory()
        do {
            // Pega tudo que tem na pasta do aplicativo
            let urls = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            // Filtra só os áudios .m4a e ordena do mais novo para o mais velho
            self.recordings = urls.filter { $0.pathExtension == "m4a" }.sorted(by: { $0.path > $1.path })
        } catch {
            print("Erro ao buscar áudios: \(error)")
        }
    }
    
    func playAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Erro ao tentar tocar o áudio: \(error)")
        }
    }
    // Configura a pasta segura do iPhone (Documents)
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        // Pedimos permissão para o usuário na primeira vez
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Falha ao configurar a sessão de áudio")
        }
        
        // Criamos um nome único para o arquivo usando a data atual
        let fileName = "gravacao_\(Date().timeIntervalSince1970).m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        
        // Configurações de qualidade (m4a, boa compressão)
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
               // No finalzinho da sua função stopRecording(), coloque:
               if let start = startTime {
                   lastRecordingDuration = Date().timeIntervalSince(start)
               }
            isRecording = true
        } catch {
            print("Não foi possível iniciar a gravação")
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        // Salvamos a URL para podermos guardar no Banco de Dados depois!
        lastRecordedAudioURL = audioRecorder?.url
    }
}
