import Foundation

import Foundation
import Netable

struct GetDogsRequest: Request {
    typealias Parameters = Empty
    typealias RawResource = [DogImage]

    public var method = HTTPMethod.get
    public var path = "v1/images/search?format=json&limit=10"
}
