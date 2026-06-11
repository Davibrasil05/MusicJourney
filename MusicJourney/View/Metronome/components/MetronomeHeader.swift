import SwiftUI

struct MetronomeHeader: View {
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            Text("Metrônomo")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(.systemGray3))
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 16)
    }
}
