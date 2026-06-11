import SwiftUI

struct BeatIndicatorView: View {
    var currentBeat: Int
    var beatsPerMeasure: Int
    var isPlaying: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(1...beatsPerMeasure, id: \.self) { beat in
                Circle()
                    .fill(beatColor(for: beat))
                    .frame(
                        width: beatSize(for: beat),
                        height: beatSize(for: beat)
                    )
                    .animation(.easeInOut(duration: 0.1), value: currentBeat)
            }
        }
    }
    
    private func beatColor(for beat: Int) -> Color {
        if isPlaying && beat == currentBeat {
            return .orange
        }
        return Color(.systemGray4)
    }
    
    private func beatSize(for beat: Int) -> CGFloat {
        if isPlaying && beat == currentBeat {
            return 32
        }
        return 24
    }
}
