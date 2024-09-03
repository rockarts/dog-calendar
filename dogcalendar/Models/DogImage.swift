import Foundation

struct DogImage: Codable, Identifiable {
    let id: String
    let url: String
    let date: Date?
}
