//import SwiftUI
//
//struct TestAudioRecordingView: View {
//    // Puxa o serviço de áudio que sabe ler e tocar arquivos
//    @StateObject private var audioRecorder = AudioRecorderService()
//    
//    var body: some View {
//        VStack(spacing: 30) {
//            Image(systemName: "waveform.circle.fill")
//                .font(.system(size: 80))
//                .foregroundColor(audioRecorder.isRecording ? .red : .gray)
//            
//            Text(audioRecorder.isRecording ? "Gravando..." : "Toque para gravar")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(audioRecorder.isRecording ? .red : .primary)
//            
//            // O Botão de Microfone
//            Button(action: {
//                if audioRecorder.isRecording {
//                    audioRecorder.stopRecording()
//                    // Uma pequena pausa para o iPhone ter tempo de salvar o arquivo antes de ler a lista
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        audioRecorder.fetchRecordings()
//                    }
//                } else {
//                    audioRecorder.startRecording()
//                }
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(audioRecorder.isRecording ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
//                        .frame(width: 100, height: 100)
//                    
//                    Circle()
//                        .fill(audioRecorder.isRecording ? Color.red : Color.blue)
//                        .frame(width: 70, height: 70)
//                    
//                    Image(systemName: audioRecorder.isRecording ? "stop.fill" : "mic.fill")
//                        .font(.system(size: 30))
//                        .foregroundColor(.white)
//                }
//            }
//            
//            // Lista de Áudios Salvos
//            List {
//                Section(header: Text("Minhas Gravações Salvas")) {
//                    if audioRecorder.recordings.isEmpty {
//                        Text("Nenhum áudio gravado ainda.")
//                            .foregroundColor(.gray)
//                    }
//                    
//                    ForEach(audioRecorder.recordings, id: \.self) { url in
//                        HStack {
//                            Text(url.lastPathComponent)
//                                .font(.caption)
//                                .lineLimit(1)
//                                .truncationMode(.middle)
//                            
//                            Spacer()
//                            
//                            // Botão de dar Play
//                            Button(action: {
//                                audioRecorder.playAudio(url: url)
//                            }) {
//                                Image(systemName: "play.circle.fill")
//                                    .foregroundColor(.green)
//                                    .font(.title2)
//                            }
//                        }
//                    }
//                }
//            }
//            .listStyle(PlainListStyle())
//            .onAppear {
//                audioRecorder.FetchedResults()// Carrega a lista ao abrir a tela
//            }
//        }
//        .navigationTitle("Gravação")
//    }
//}
