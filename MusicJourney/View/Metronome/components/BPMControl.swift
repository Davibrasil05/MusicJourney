import SwiftUI

struct BPMControl: View {
    @Binding var bpm: Double
    var isPlaying: Bool
    var onTogglePlay: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onTogglePlay) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(bpm)) BPM")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Slider(value: $bpm, in: 40...240, step: 1)
                    .accentColor(.orange)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
                .background(Color.clear)
        )
    }
}
