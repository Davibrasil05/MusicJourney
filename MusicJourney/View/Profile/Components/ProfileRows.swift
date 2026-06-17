//
//  ProfileRows.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI


struct ProfilePickerRow<Content: View>: View {
    let title: String
    let value: String
    @ViewBuilder let picker: Content

    var body: some View {
        ProfileCard {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(Color("textDark"))
                }
                Spacer()
                HStack(spacing: 6) {
                    picker
                        .labelsHidden()
                        .accentColor(Color("headerGreen"))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color("headerGreen"))
                }
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
                    .foregroundColor(.secondary)
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
                        .foregroundColor(.secondary)
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
