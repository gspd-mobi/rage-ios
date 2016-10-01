import Foundation

class StubData {

    var mode: StubMode
    var data: Data

    init(data: Data, mode: StubMode) {
        self.data = data
        self.mode = mode
    }

}
