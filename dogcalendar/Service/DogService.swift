import Foundation
import Netable
import NiceArchitecture

struct DogServiceKey: InjectionKey {
    static var currentValue: DogServiceProtocol = DogService()
}

protocol DogServiceProtocol {
    func getDogs() async throws -> [DogImage]
}

class DogService: DogServiceProtocol {
    private let netable = Netable(baseURL: URL(string: "https://api.thedogapi.com/")!)

    func getDogs() async throws -> [DogImage] {
        try await netable.request(GetDogsRequest())
    }
}
