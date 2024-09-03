import XCTest
import NiceArchitecture

@testable import dogcalendar

final class DogCalendarRepositoryTests: XCTestCase {
    
    @TestData("DogImage") private var dogImages: [DogImage]
    
    let current = Calendar.current
    var repo: DogCalendarRepositoryProtocol?
    
    override func setUpWithError() throws {
        repo = DogCalendarRepository(cache: CacheService())
    }

    override func tearDownWithError() throws {
        
    }

    func testSetupCalendarFromImagesForOneWeek() async throws {
        let result = try await repo!.createDogCalendar(images: dogImages, cacheMode: .noCache)
        XCTAssert(result.count == 7)
    }
    
    func testCaldendarIsSundayThroughSaturday() async throws {
        let result = try await repo!.createDogCalendar(images: dogImages, cacheMode: .noCache)
        dump(result)
        XCTAssert(result.count == 7)
        
        XCTAssert(.sunday == Weekday(rawValue:current.component(.weekday, from: result[0].date)))
        XCTAssert(.monday == Weekday(rawValue:current.component(.weekday, from: result[1].date)))
        XCTAssert(.tuesday == Weekday(rawValue:current.component(.weekday, from: result[2].date)))
        XCTAssert(.wednesday == Weekday(rawValue:current.component(.weekday, from: result[3].date)))
        XCTAssert(.thursday == Weekday(rawValue:current.component(.weekday, from: result[4].date)))
        XCTAssert(.friday == Weekday(rawValue:current.component(.weekday, from: result[5].date)))
        XCTAssert(.saturday == Weekday(rawValue:current.component(.weekday, from: result[6].date)))
    }
    
    func testTodayIsCurrentDay() async throws {
        let result = try await repo!.createDogCalendar(images: dogImages, cacheMode: .noCache)
        
        let today = Date()
        
        let currentDay = result.first{
            $0.isCurrentDay
        }
        let todayComponents = current.dateComponents([.year, .month, .day], from: today)
        let currentDayComponents = current.dateComponents([.year, .month, .day], from: currentDay!.date)
        XCTAssert(todayComponents == currentDayComponents)
    }
    
    func testShouldReturnEmptyListWhenNoDataAvailable() async throws {
        let result = try await repo!.createDogCalendar(images:[], cacheMode: .noCache)
        XCTAssert(0 == result.count)
    }
}
