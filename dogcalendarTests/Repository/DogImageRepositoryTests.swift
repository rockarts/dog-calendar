
import XCTest
import Combine

import NiceArchitecture

@testable import dogcalendar
final class DogImageRepositoryTests: XCTestCase {

        var dogRepository:  DogRepositoryProtocol!
        var cancellables = Set<AnyCancellable>()

        override func setUp() {
            super.setUp()

            InjectedValues[\.dogService] = MockDogService()
            dogRepository = DogRepository(cache: CacheService())
        }

        func testShouldPassthroughGetDogList() {
            let expectation = XCTestExpectation(description: "Dog images should be passed through")
            
            dogRepository.dogList
                .sink { _ in
                    expectation.fulfill()
                }.store(in: &cancellables)

            Task {
                let dogs = try? await dogRepository.getDogList(cacheMode: .cacheAndUpdate)

                XCTAssertNotNil(dogs)
            }

            wait(for: [expectation], timeout: 1.0)

            XCTAssert(true)
        }

}
