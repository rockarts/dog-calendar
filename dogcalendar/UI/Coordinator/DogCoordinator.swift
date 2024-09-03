import Foundation


class DogCoordinator: ObservableObject, Coordinator {
    @Published var viewModel: DogViewModel!

    init() {
        viewModel = DogViewModel(coordinator: self)
    }
}
