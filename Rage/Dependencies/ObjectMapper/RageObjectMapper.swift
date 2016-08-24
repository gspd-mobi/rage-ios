import Foundation
import ObjectMapper

extension RageRequest {

    public func bodyJson(value: Mappable) -> RageRequest {
        guard let json = value.toJSONString() else {
            return self
        }
        return bodyString(json)
    }

}
