//
//  YoutubeURLInputSheet.swift
//  MusicJourney
//

import SwiftUI

struct YoutubeURLInputSheet: View {

    /// Called with the resolved videoID when the user confirms a valid URL.
    let onOpen: (String) -> Void
    let onCancel: () -> Void

    @State private var urlText: String = ""
    @State private var errorMessage: String? = nil

    private var canConfirm: Bool {
        !urlText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cole o link do YouTube abaixo para abrir o vídeo flutuante durante a prática.")
                        .font(.subheadline)
                        .foregroundColor(Color("textDark").opacity(0.75))

                    TextField("https://youtu.be/...", text: $urlText)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(14)
                        .background(Color("cardCream"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    errorMessage != nil ? Color.red : Color("inputGray"),
                                    lineWidth: 1
                                )
                        )
                        .onChange(of: urlText) { _ in
                            errorMessage = nil
                        }

                    if let error = errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }

                Button(action: handleOpen) {
                    Text("Abrir vídeo")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(canConfirm ? Color("headerGreen") : Color("inputGray"))
                        .cornerRadius(12)
                }
                .disabled(!canConfirm)

                Spacer()
            }
            .padding(24)
            .background(Color("cardCream").ignoresSafeArea())
            .navigationTitle("Abrir vídeo do YouTube")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 22))
                    }
                }
            }
        }
    }

    private func handleOpen() {
        let trimmed = urlText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let videoID = YouTubeURLParser.extractVideoID(from: trimmed) else {
            errorMessage = "URL inválida. Cole um link do YouTube válido."
            return
        }
        onOpen(videoID)
    }
}

struct YoutubeURLInputSheet_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeURLInputSheet(onOpen: { _ in }, onCancel: {})
            .previewDisplayName("YoutubeURLInputSheet")
    }
}
