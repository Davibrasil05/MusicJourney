import SwiftUI

struct BPMAdjustButtonsView: View {
    var onDecrement: () -> Void
    var onIncrement: () -> Void
    var onStop: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Button(action: onStop) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
            }
        }
    }
}
