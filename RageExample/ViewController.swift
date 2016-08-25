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
        _ = ExampleAPI.sharedInstance.getSomething()
        .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            (s) in
            self.textView.text = "\(s)"
        }, onError: {
            (error) in
            print((error as? RageError)?.message ?? "")
        }, onCompleted: {
        }, onDisposed: {
        })
    }

}
