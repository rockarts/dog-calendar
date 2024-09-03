import Foundation
import NiceArchitecture

extension InjectedValues {

    // REPOSITORIES

    var dogRepository: DogRepositoryProtocol {
        get { Self[DogRepositoryKey.self] }
        set { Self[DogRepositoryKey.self] = newValue }
    }
    
    var dogCalendarRepository: DogCalendarRepositoryProtocol {
        get { Self[DogCalendarRepositoryKey.self] }
        set { Self[DogCalendarRepositoryKey.self] = newValue }
    }

    // SERVICES

    var errorService: ErrorService {
        get { Self[ErrorServiceKey.self] }
        set { Self[ErrorServiceKey.self] = newValue }
    }

    var dogService: DogServiceProtocol {
        get { Self[DogServiceKey.self] }
        set { Self[DogServiceKey.self] = newValue }
    }
}
