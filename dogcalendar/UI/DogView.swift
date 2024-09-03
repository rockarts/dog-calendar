import NiceArchitecture
import SwiftUI

struct DogView: View {
    @ObservedObject private var viewModel: DogViewModel
    
    var body: some View {
        StatefulView(
            state: viewModel.contentLoadState,
            hasDataView: { dogsView },
            errorView: { error in
                errorView
            }, loadingView: {
                loadingView
            }
        )
        .bindToVM(viewModel)
    }
    
    init(viewModel: DogViewModel) {
        self.viewModel = viewModel
    }
    
    private var loadingView: some View {
        ForEach(0..<7) { _ in
            EmptyCell()
        }
    }
    
    private var errorView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Something's gone wrong! Try reloading.").padding()
                Spacer()
            }
            Spacer()
        }
    }
    
    private var dogsView: some View {
        List(viewModel.allDogs, id: \.id) { dog in
            DogImageView(viewState: dog)
                .cornerRadius(10)
        }
    }
}

