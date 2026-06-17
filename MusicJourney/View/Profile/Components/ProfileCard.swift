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
        HStack{
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.black)
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
