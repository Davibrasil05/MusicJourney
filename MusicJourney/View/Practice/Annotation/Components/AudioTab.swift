//
//  AudioTab.swift
//  MusicJourney
//
//  Created by Academy on 17/06/26.
//

import SwiftUI


struct AudioTab: View {
    var goal: Goal
    @ObservedObject var recordingRepo = RecordingRepository()
    @ObservedObject var audioService = AudioRecorderService()
    
    @Binding var showingEditModal: Bool
    @Binding var newTitle: String
    @Binding var itemToEdit: EditItemType?
    
    var body: some View {
        let groupedRecordings = groupRecordingsByDate(recordingRepo.recordings)
        
        if groupedRecordings.isEmpty {
            Text("Nenhum áudio encontrado. Comece a gravar!")
                .foregroundColor(.gray)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(groupedRecordings, id: \.date) { group in
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(group.date)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    ForEach(group.items) { recording in
                        RecordingCard(
                            recording: recording,
                            audioService: audioService,
                            onEdit: {
                                itemToEdit = .audio(recording)
                                newTitle = recording.title ?? ""
                                withAnimation { showingEditModal = true }
                            },
                            onDelete: {
                                audioService.stopAudio()
                                recordingRepo.deleteRecording(recording)
                            }
                        )
                    }
                }
            }
        }
    }
    struct DateGroup {
        let date: String
        let items: [Recording]
    }
    func groupRecordingsByDate(_ recordings: [Recording]) -> [DateGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dictionary = Dictionary(grouping: recordings) { rec -> String in
            guard let date = rec.createdAt else { return "Desconhecido" }
            return formatter.string(from: date)
        }
        
        return dictionary.map { DateGroup(date: $0.key, items: $0.value) }
        .sorted { $0.date > $1.date }
    }
}
