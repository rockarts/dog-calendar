import Combine
import Foundation
import NiceArchitecture

struct ErrorServiceKey: InjectionKey {
    static var currentValue = ErrorService()
}

class ErrorService {
    private var cancellables = [AnyCancellable]()

    private let incomingError = PassthroughSubject<Error, Never>()
    var didReceiveDisplayableError = PassthroughSubject<DisplayableError, Never>()

    init() {
        incomingError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else { return }

                if let loggableError = error as? LoggableError {
                    loggableError.log()
                } else {
                    self.logUnhandled(error: error)
                }

                if let displayError = error as? DisplayableError {
                    self.didReceiveDisplayableError.send(displayError)
                    return
                }

                self.didReceiveDisplayableError.send(UnknownError(message: error.localizedDescription))
                clog.info("Showing unknown error: \(error)")
            }.store(in: &cancellables)
    }

    func capture(_ error: Error) {
        if let loggableError = error as? LoggableError, loggableError.isConnectionError {
            incomingError.send(ConnectivityError())
            return
        }

        incomingError.send(error)
    }

    private func logUnhandled(error: Error) {
        switch error {
        case let decodingError as DecodingError:
            clog.error("Decoding error", info: decodingError.errorDescription)
        default:
            clog.info("An unknown or unhandled error occurred: \(error.localizedDescription)")
        }
    }
}
