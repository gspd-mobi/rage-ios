import Foundation

open class TypedObject {

    let mimeType: String
    let object: Data
    let fileName: String?

    public init(_ object: Data, mimeType: String, fileName: String? = nil) {
        self.object = object
        self.mimeType = mimeType
        self.fileName = fileName
    }

}
