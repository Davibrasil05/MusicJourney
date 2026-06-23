//
//  ProfileRows.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI

struct ProfilePickerRow<Option: Hashable>: View {
    let title: String
    @Binding var selection: Option
    let options: [Option]
    let optionLabel: (Option) -> String

    var body: some View {
        ProfileCard {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        if option == selection {
                            Label(optionLabel(option), systemImage: "checkmark")
                        } else {
                            Text(optionLabel(option))
                        }
                    }
                }
            } label: {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(Color("textDark").opacity(0.6))
                        Text(optionLabel(selection))
                            .font(.body.bold())
                            .foregroundColor(Color("textDark"))
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color("headerGreen"))
                }
                .contentShape(Rectangle())
            }
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        ProfileCard {
            HStack {
                Text(title)
                    .font(.body.bold())
                    .foregroundColor(Color("textDark"))
                Spacer()
                Text(value)
                    .font(.body.bold())
                    .foregroundColor(Color("textDark").opacity(0.6))
            }
        }
    }
}

struct ProfileNavigationRow: View {
    let title: String
    let value: String

    var body: some View {
        ProfileCard {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(Color("textDark").opacity(0.6))
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(Color("textDark"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color("headerGreen"))
            }
        }
    }
}

struct ProfileRows_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            ProfilePickerRow(
                title: "Instrumento",
                selection: .constant(MusicInstrument.violao),
                options: MusicInstrument.allCases,
                optionLabel: { $0.rawValue }
            )

            ProfileInfoRow(title: "Nível Musical", value: "Lev. 11")

            ProfileNavigationRow(title: "Gêneros", value: "Rock, MPB")
        }
        .padding()
        .background(Color("cardCream"))
        .previewDisplayName("ProfileRows")
    }
}
