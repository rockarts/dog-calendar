import Foundation
import SwiftUI

struct DogCalendar: Codable, Identifiable {
    let id: String
    let url: String
    let date: Date
    let isCurrentDay: Bool
}
