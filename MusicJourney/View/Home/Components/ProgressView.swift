//
//  ProgressView.swift
//  MusicJourney
//
//  Created by Academy on 11/06/26.
//

import SwiftUI
struct LevelProgressBar: View {
    var percentage: Double // 0.0 a 1.0 (ex: 45% = 0.45)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
               
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("cardCream"))
                    .frame(height: 27)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("primaryBlue"))
                    .frame(width: geometry.size.width * CGFloat(percentage), height: 27)
            }
        }
        .frame(height: 27)
    }
}

struct LevelProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LevelProgressBar(percentage: 0.45)
                .padding()
                .background(Color("headerGreen"))
                .previewDisplayName("45%")

            LevelProgressBar(percentage: 0.0)
                .padding()
                .background(Color("headerGreen"))
                .previewDisplayName("0%")

            LevelProgressBar(percentage: 1.0)
                .padding()
                .background(Color("headerGreen"))
                .previewDisplayName("100%")
        }
    }
}
