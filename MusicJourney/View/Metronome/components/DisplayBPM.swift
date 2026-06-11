import SwiftUI

struct DisplayBPM: View {
    var bpm: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Int(bpm))")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            
            Text("BPM")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
    }
}
