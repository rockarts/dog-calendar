import Combine
import NiceArchitecture

@testable import dogcalendar

class MockDogCalendarRepository: DogCalendarRepositoryProtocol {
    var dogCalendar = PassthroughSubject<[DogCalendar], Never>()

    private var calendar: [DogCalendar]

    init(calendar: [DogCalendar]) {
        self.calendar = calendar
    }

    func createDogCalendar(images: [dogcalendar.DogImage], cacheMode: NiceArchitecture.CacheMode) async throws -> [dogcalendar.DogCalendar] {
        calendar
    }
}
