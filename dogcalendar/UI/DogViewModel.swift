import Foundation
import NiceArchitecture

class DogViewModel : ObservableVM {
    @Injected(\.dogRepository) private var dogRepo: DogRepositoryProtocol
    @Injected(\.dogCalendarRepository) private var dogCalendarRepo: DogCalendarRepositoryProtocol
    
    private unowned let coordinator: DogCoordinator
    
    init(coordinator: DogCoordinator) {
        self.coordinator = coordinator
    }
    
    @Published var allDogs: [DogViewState] = []
    
    override func bindViewModel() {
        super.bindViewModel()
        fetchDogs()
    }
    
    private func fetchDogs() {
        contentLoadState = .loading
        
        Task { @MainActor in
            do {
                struct Raw {
                    var dogs: [DogImage]
                    var dogCalendar: [DogCalendar]
                }
                
                let rawDogs = try await dogRepo.getDogList(cacheMode: .cacheAndUpdate)
                async let rawDogCalendar = try dogCalendarRepo.createDogCalendar(images: rawDogs, cacheMode: .noCache)
                let raw = try Raw(dogs: rawDogs, dogCalendar: await rawDogCalendar)
                self.allDogs = raw.dogCalendar.compactMap { dog in
                    return DogViewState(id: dog.id, url: dog.url, date: dog.date, isCurrentDay: dog.isCurrentDay)
                }
                
                contentLoadState = self.allDogs.isEmpty ? .noData : .hasData
            } catch {
                errorService.error.send(error)
            }
        }
    }
}
