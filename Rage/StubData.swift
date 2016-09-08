import Foundation

class StubData {

    var mode: StubMode
    var data: NSData

    init(data: NSData, mode: StubMode) {
        self.data = data
        self.mode = mode
    }

}
