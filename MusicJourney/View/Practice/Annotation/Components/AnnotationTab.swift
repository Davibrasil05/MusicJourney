//
//  AnnotationTab.swift
//  MusicJourney
//
//  Created by Academy on 17/06/26.
//

import SwiftUI

struct AnnotationTab: View {
    
    var goal: Goal
    @ObservedObject var annotationRepo = AnnotationRepository()
    
    @Binding var showingEditModal: Bool
    @Binding var newTitle: String
    @Binding var itemToEdit: EditItemType?
    
    @Binding var isNoteDetailActive: Bool
    @Binding var noteToOpen: Annotation?
   
    
    var body: some View {
        
        let groupedAnnotations = groupAnnotationsByDate(annotationRepo.annotations)
        
        if groupedAnnotations.isEmpty {
            Text("Nenhuma anotação encontrada.")
                .foregroundColor(.gray)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(groupedAnnotations, id: \.date) { group in
                VStack(alignment: .leading, spacing: 16) {
                    // Título da Data
                    HStack {
                        Image(systemName: "calendar")
                        Text(group.date)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // Cards das Anotações
                    ForEach(group.items) { annotation in
                        AnnotationCard(
                            annotation: annotation,
                            onEdit: {
                                itemToEdit = .nota(annotation)
                                newTitle = annotation.title ?? ""
                                withAnimation { showingEditModal = true }
                            },
                            onDelete: {
                                annotationRepo.deleteAnnotation(annotation)
                            }
                        )
                            .onTapGesture {
                                noteToOpen = annotation
                                isNoteDetailActive = true
                            }
                    }
                }
            }
        }
    }
    struct AnnotationDateGroup {
        let date: String
        let items: [Annotation]
    }
    
    func groupAnnotationsByDate(_ annotations: [Annotation]) -> [AnnotationDateGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dictionary = Dictionary(grouping: annotations) { ann -> String in
            guard let date = ann.createdAt else { return "Desconhecido" }
            return formatter.string(from: date)
        }
        
        return dictionary.map { AnnotationDateGroup(date: $0.key, items: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
