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
        _ = ExampleAPI.sharedInstance.getOrganization()
        .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            (s) in
            self.textView.text = "\(s)"
        }, onError: {
            (error: ErrorType) in

            let message = error.description()

            let alert = UIAlertController(title: "Error", message: message,
                    preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok",
                    style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }, onCompleted: {
        }, onDisposed: {
        })
    }

}
