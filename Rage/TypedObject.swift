import Foundation

open class TypedObject {

    let mimeType: String
    let data: Data
    let fileName: String?

    public init(_ data: Data, mimeType: String, fileName: String? = nil) {
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }

}
