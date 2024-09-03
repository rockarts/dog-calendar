import Combine
import Foundation
import NiceArchitecture

struct DogRepositoryKey: InjectionKey {
    static var currentValue: DogRepositoryProtocol = DogRepository(cache: CacheService())
}

protocol DogRepositoryProtocol {
    var dogList: PassthroughSubject<[DogImage], Never> { get set }

    @discardableResult func getDogList(cacheMode: CacheMode) async throws -> [DogImage]
}

class DogRepository: DogRepositoryProtocol {
    @Injected(\.dogService) private var DogService: DogServiceProtocol

    private enum CacheKeys {
        static let dogList = CacheKey<[DogImage]>(key: "DogList")
    }

    private let cache: CacheService

    
    var dogList = PassthroughSubject<[DogImage], Never>()

    init(cache: CacheService) {
        self.cache = cache
    }


    @discardableResult func getDogList(cacheMode: CacheMode) async throws -> [DogImage] {
        let key = CacheKeys.dogList
        if let cached = await cache.retrieve(key: key, cacheMode: cacheMode) {
            self.dogList.send(cached.result)
            if cached.shouldExit { return cached.result }
        }

        let newDogs = try await DogService.getDogs()
        await cache.updateRequest(key: key, values: newDogs)
        self.dogList.send(newDogs)
        return newDogs
    }
}
