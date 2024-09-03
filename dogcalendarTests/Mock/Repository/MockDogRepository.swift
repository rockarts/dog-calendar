import Combine
import NiceArchitecture

@testable import dogcalendar

class MockDogRepository: DogRepositoryProtocol {
    var dogList = PassthroughSubject<[DogImage], Never>()

    private var dogs: [DogImage]

    init(dogs: [DogImage]) {
        self.dogs = dogs
    }

    func getDogList(cacheMode: NiceArchitecture.CacheMode) async throws -> [dogcalendar.DogImage] {
        dogs
    }
}
