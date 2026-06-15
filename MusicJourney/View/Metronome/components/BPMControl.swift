import SwiftUI

struct BPMControl: View {
    @Binding var bpm: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
//            Text("\(Int(bpm)) BPM")
//                .font(.caption)
//                .fontWeight(.bold)
//                .foregroundColor(.black)
            
            Slider(value: $bpm, in: 40...240, step: 1)
                .accentColor(.orange)
        }
        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 50)
//                .fill(Color("backgroundCards"))
//        )
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
