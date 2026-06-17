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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(Color("headerGreen"))
                }
                Spacer()
                picker
                    .labelsHidden()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    let valueColor: Color

    var body: some View {
        ProfileCard {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
                Text(value)
                    .font(.body.bold())
                    .foregroundColor(valueColor)
            }
        }
    }
}

struct ProfileNavigationRow: View {
    let title: String
    let value: String

    var body: some View {
        ProfileCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.bold())
                        .foregroundColor(Color("headerGreen"))
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
        }
    }
}
