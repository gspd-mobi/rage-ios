import UIKit
import RxSwift
import Rage

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonClicked(sender: AnyObject) {
        exampleRequest()
    }

    func exampleRequest() {
        _ = ExampleAPI.sharedInstance.getSomethingError()
        .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            (s) in
            self.textView.text = "\(s)"
        }, onError: {
            (error: ErrorType) in

        }, onCompleted: {
        }, onDisposed: {
        })
    }

}
