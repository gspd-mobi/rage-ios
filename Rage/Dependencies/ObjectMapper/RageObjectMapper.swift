import Foundation
import ObjectMapper

extension RageRequest {

    public func bodyJson(value: Mappable) -> RageRequest {
        if !httpMethod.hasBody() {
            preconditionFailure(self.wrongHttpMethodForBodyErrorMessage)
        }

        guard let json = value.toJSONString() else {
            return self
        }
        return bodyString(json)
    }

}
