import SwiftUI

struct DisplayCompass: View {
    var beatsPerMeasure: Int
    var onTap: () -> Void
    
    private var signatureText: String {
        switch beatsPerMeasure {
        case 6: return "6/8"
        default: return "\(beatsPerMeasure)/4"
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(signatureText)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            
            Text("Compasso")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            onTap()
        }
    }
}
