import Combine
import Foundation
import NiceArchitecture

struct DogCalendarRepositoryKey: InjectionKey {
    static var currentValue: DogCalendarRepositoryProtocol = DogCalendarRepository(cache: CacheService())
}

protocol DogCalendarRepositoryProtocol {
    var dogCalendar: PassthroughSubject<[DogCalendar], Never> { get set }
    
    @discardableResult func createDogCalendar(images:[DogImage], cacheMode: CacheMode) async throws -> [DogCalendar]
}

class DogCalendarRepository: DogCalendarRepositoryProtocol {
    
    private enum CacheKeys {
        static let dogCalendar = CacheKey<[DogCalendar]>(key: "DogCalendarList")
    }
    
    private let cache: CacheService
    
    var dogCalendar = PassthroughSubject<[DogCalendar], Never>()
    
    init(cache: CacheService) {
        self.cache = cache
    }
    
    @discardableResult func createDogCalendar(images:[DogImage], cacheMode: CacheMode) async throws -> [DogCalendar] {
        guard images.count > 0 && images.count >= 7 else {
            return []
        }
        
        let key = CacheKeys.dogCalendar
        if let cached = await cache.retrieve(key: key, cacheMode: cacheMode) {
            self.dogCalendar.send(cached.result)
            if cached.shouldExit { return cached.result }
        }
        
        let calendar = Calendar.current
        let today = Date()
        let weekdayIndex = calendar.component(.weekday, from: today) - 1 // 0 (Sunday) to 6 (Saturday)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let newCalendar = (0..<7).map { offset in
            let dayOffset = offset - weekdayIndex
            let date = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            
            return DogCalendar(
                id: images[offset].id, url: images[offset].url, date: date, isCurrentDay: calendar.isDateInToday(date)
            )
        }
        await cache.updateRequest(key: key, values: newCalendar)
        self.dogCalendar.send(newCalendar)
        return newCalendar
    }
}
