import Foundation

public class TypedObject {

    let mimeType: String
    let object: NSData

    public init(_ object: NSData, mimeType: String) {
        self.object = object
        self.mimeType = mimeType
    }

}
