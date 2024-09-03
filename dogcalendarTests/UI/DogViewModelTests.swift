import XCTest
import Combine
import NiceArchitecture

@testable import dogcalendar

final class DogViewModelTests: XCTestCase {
    var viewModel: DogViewModel!
    var cancellables = Set<AnyCancellable>()
    
    @TestData("DogImage") private var dogImages: [DogImage]
    private var dogCalendar = DogCalendarData().data
    
    override func setUpWithError() throws {
        super.setUp()
        
        InjectedValues[\.dogRepository] = MockDogRepository(dogs: dogImages)
        InjectedValues[\.dogCalendarRepository] = MockDogCalendarRepository(calendar: dogCalendar)
        
        viewModel = DogViewModel(coordinator: DogCoordinator())
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
    }
    
    func testSuccessfulContentLoadStates() {
        XCTAssertEqual(viewModel.contentLoadState, .noData)
        
        let expectation = XCTestExpectation(description: "Dogs should populate")
        viewModel.$allDogs
            .dropFirst()
            .sink { vm in
                expectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.bindViewModel()
        
        XCTAssertEqual(viewModel.contentLoadState, .loading)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.contentLoadState, .hasData)
    }
}
