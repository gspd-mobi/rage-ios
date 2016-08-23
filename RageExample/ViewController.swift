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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        _ = ExampleAPI.sharedInstance.getOrgRepositories()
        .subscribeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            (s) in
            var text = ""
            s.forEach {
                (repository: GithubRepository) in
                text += "\(repository.fullName ?? ""): \(repository.stars ?? 0)\n"
            }
            self.textView.text = self.textView.text + "\(text)"
        }, onError: {
            (error) in
            print((error as? RageError)?.message ?? "")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, onCompleted: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, onDisposed: {
        })
    }

}
