//
//  GenrePicker.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI


struct GenrePickerView: View {
    @Binding var selectedGenres: Set<MusicGenre>
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("cardCream").ignoresSafeArea()

            List {
                ForEach(MusicGenre.allCases) { genre in
                    Button(action: { toggle(genre) }) {
                        HStack {
                                Text(genre.rawValue)
                                    .foregroundColor(Color("textDark"))
                            Spacer()
                            if selectedGenres.contains(genre) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("headerGreen"))
                            }
                        }
                    }
                    .listRowBackground(Color("backgroundCards"))
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Gêneros")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Voltar")
                    }
                    .foregroundColor(Color("headerGreen"))
                }
            }
        }
        
    }

    private func toggle(_ genre: MusicGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }
}
