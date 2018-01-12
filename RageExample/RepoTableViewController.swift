import UIKit
import RxSwift

class GithubOrganizationPage {
    var info: GithubOrganization
    var repos: [GithubRepository]

    init(info: GithubOrganization, repos: [GithubRepository]) {
        self.info = info
        self.repos = repos
    }
}

class RepoTableViewController: UITableViewController {

    let org = "gspd-mobi"

    var info: GithubOrganization?
    var repos: [GithubRepository] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        obtainPageContent()
    }

    @IBAction func didTapRefreshButton(_ sender: AnyObject) {
        info = nil
        repos = []
        self.tableView.reloadData()
        obtainPageContent()
    }

    func obtainPageContent() {
        _ = Observable.zip(ExampleAPI.sharedInstance.getOrgInfo(org: org),
                           ExampleAPI.sharedInstance.getOrgRepositories(org: org)) { info, repos in
                    return GithubOrganizationPage(info: info, repos: repos)
                }
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in
                    self.info = page.info
                    self.repos = page.repos
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return info == nil ? 0 : 3
        case 1: return repos.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return info == nil ? nil : "Info"
        case 1: return repos.isEmpty ? nil : "Repos"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, 0): cell.textLabel?.text = info?.name
        cell.selectionStyle = .none
        case (0, 1): cell.textLabel?.text = info?.location
        cell.selectionStyle = .none
        case (0, 2):
            cell.textLabel?.text = "Go to Site..."
            cell.textLabel?.textColor = UIColor.blue
            cell.selectionStyle = .none
        case (1, _):
            let repo = repos[indexPath.row]
            cell.textLabel?.text = repo.name
            cell.accessoryType = .disclosureIndicator
        default: break
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            guard let siteUrl = info?.blog else {
                break
            }
            let url = URL(string: siteUrl)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case (1, _):
            let vc = ContributorsTableViewController(nibName: "TableViewController", bundle: nil)
            vc.repo = repos[indexPath.row].name
            vc.org = org
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }

}
