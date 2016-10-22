import UIKit
import RxSwift
import Rage

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonClicked(_ sender: AnyObject) {
        exampleRequest()
    }

    func exampleRequest() {
        _ = ExampleAPI.sharedInstance.getOrgRepositories()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                (s) in
                self.textView.text = "\(s)"
                }, onError: {
                    (error: Error) in

                    let message = error.description()

                    let alert = UIAlertController(title: "Error", message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }, onCompleted: {
                }, onDisposed: {
            })
    }

}
