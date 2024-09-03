import SwiftUI

@main
struct dogcalendarApp: App {
    var body: some Scene {
        WindowGroup {
            DogCoordinatorView(coordinator: DogCoordinator())
        }
    }
}
