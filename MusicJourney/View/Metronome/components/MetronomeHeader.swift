import SwiftUI

struct MetronomeHeader: View {
    var onClose: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Metrônomo")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}
