import SwiftUI

struct AnnotationCard: View {
    let annotation: Annotation
    let onEdit: () -> Void
    let onDelete: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Lado Laranja
                ZStack {
                    Color("headerGreen")
                    Image(systemName: "square.and.pencil")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(width: 80)
                
                // Dados e Botões
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(annotation.title ?? "Nota sem título")
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Text(annotation.text ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                        
                        if let date = annotation.createdAt {
                            Text(formatDate(date))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Os 3 Pontinhos
                    Menu {
                        Button(action: onEdit) { Label("Editar nome", systemImage: "pencil") }
                        Button(role: .destructive, action: onDelete) { Label("Excluir", systemImage: "trash") }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
                .background(Color.white)
            }
            .frame(minHeight: 80)
        }
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("headerGreen"), lineWidth: 1))
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy • HH:mm"; return f.string(from: date)
    }
}

