import Foundation
@testable import dogcalendar

class MockDogService: DogServiceProtocol {
    @TestData("DogImage") private var dogImages: [DogImage]
    
    func getDogs() async throws -> [dogcalendar.DogImage] {
        dogImages
    }
}
