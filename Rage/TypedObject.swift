import Foundation

public class TypedObject {

    let mimeType: String
    let object: NSData
    let fileName: String?

    public init(_ object: NSData, mimeType: String, fileName: String? = nil) {
        self.object = object
        self.mimeType = mimeType
        self.fileName = fileName
    }

}
