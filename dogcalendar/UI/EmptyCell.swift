import SwiftUI

struct EmptyCell: View {
    var body: some View {
        HStack {
            Spacer()
        }.frame(minHeight: 64)
        .background(Color(hex: "F2F2F7"))
        .cornerRadius(8)
        .padding(.horizontal, 8)
    }
}

#Preview {
    EmptyCell()
}
