//
//  ProfileCard.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI

struct ProfileSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
                .foregroundColor(Color("textDark"))
            Spacer()
        }
    }
}

struct ProfileCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("backgroundCards"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("headerGreen"), lineWidth: 1.5)
            )
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard {
            Text("Card de exemplo")
                .foregroundColor(Color("textDark"))
        }
        .padding()
        .background(Color("cardCream"))
        .previewDisplayName("ProfileCard")
    }
}
