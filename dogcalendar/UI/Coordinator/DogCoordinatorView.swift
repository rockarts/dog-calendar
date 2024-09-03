import Foundation
import SwiftUI

struct DogCoordinatorView: View {
    @ObservedObject var coordinator: DogCoordinator

    var body: some View {
        NavigationView {
            DogView(viewModel: coordinator.viewModel)
        }
    }
}
