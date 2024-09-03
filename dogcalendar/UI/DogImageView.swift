import Foundation
import NiceArchitecture
import SwiftUI

struct DogImageView: View {
    let viewState: DogViewState
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: viewState.url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .clipped()
                case .failure:
                    Image("photo")
                        .resizable()
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }
            .aspectRatio(contentMode: .fill)
            .clipped()
            .border(viewState.isCurrentDay ? Color(UIColor.systemYellow): Color(UIColor.systemGray), width: 10)
            VStack {
                Spacer()
                Text(viewState.date.formatted(date: .complete, time: .omitted))
                    .padding(4)
                    .font(.subheadline)
                    .bold()
                    .background(Color(UIColor.systemBackground))
                    .border(Color(UIColor.systemBlue), width: 2)
            }
        }
    }
}
