import UIKit
import RxSwift

class ContributorsTableViewController: UITableViewController {

    var repo: String!
    var org: String!
    var users: [GithubUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repo
        obtainPageContent()
    }

    func obtainPageContent() {
        _ = ExampleAPI.sharedInstance.getContributorsForRepo(repo, org: org)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { users in
                self.users = users
                self.tableView.reloadData()
                }, onError: { error in

                    let message = error.description()

                    let alert = UIAlertController(title: "Error", message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return users.isEmpty ? nil : "Contributors"
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = user.login
        cell.selectionStyle = .none
        return cell
    }

}
