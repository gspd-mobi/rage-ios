import Foundation

class TypedObject {

    let mimeType: String
    let object: NSData

    init(_ object: NSData, mimeType: String) {
        self.object = object
        self.mimeType = mimeType
    }

}
