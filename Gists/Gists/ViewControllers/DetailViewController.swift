//
//  DetailViewController.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var isStarred: Bool?
    var alertController: UIAlertController?

    func configureView() {
        // Update the user interface for the detail item.
        if let _ = self.gist {
            fetchStarredStatus()
        }
        if let detailsView = self.tableView {
            detailsView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var gist: Gist? {
        didSet {
            // only reload if we changed gists
            if oldValue?.id == gist?.id {
                return
            }
            configureView()
        }
    }

    // MARK: - table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let _ = isStarred {
                return 3
            }
            return 2
        } else {
            return gist?.files.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "About"
        } else {
            return "Files"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch (indexPath.section, indexPath.row, isStarred) {
        case (0, 0, _):
            cell.textLabel?.text = gist?.gistDescription
        case (0, 1, _):
            cell.textLabel?.text = gist?.owner?.login
        case (0, 2, .none):
            cell.textLabel?.text = ""
        case (0, 2, .some(true)):
            cell.textLabel?.text = "Unstar"
        case (0, 2, .some(false)):
            cell.textLabel?.text = "Star"
        default: // section 1
            let file = gist?.orderedFiles[indexPath.row]
            cell.textLabel?.text = file?.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row, isStarred) {
            case (0, 2, .some(true)):
                unstarThisGist()
            case (0, 2, .some(false)):
                starThisGist()
            case (1, _, _):
                guard let file = gist?.orderedFiles[indexPath.row] else {
                    return
                }
                guard let url = file.details.url else {
                    return
                }
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.title = file.name
                self.navigationController?.pushViewController(safariViewController, animated: true)
            default:
                break
        }
    }
    
    func fetchStarredStatus() {
        guard let gistId = gist?.id else {
            return
        }
        GitHubAPIManager.shared.isGistStarred(gistId) { (result) in
            guard result.error == nil else {
                print(result.error!)
                switch result.error! {
                case BackendError.autuLost:
                    self.alertController = UIAlertController(title: "Could not get starred status", message: result.error!.localizedDescription, preferredStyle: .alert)
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.alertController?.addAction(okAction)
                    self.present(self.alertController!, animated: true, completion: nil)
                    return
                default:
                    return
                }
            }
            if let status = result.value, self.isStarred == nil { // just got it
                self.isStarred = status
                self.tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            }
        }
    }
    
    func starThisGist() {
        guard let gistId = gist?.id else {
            return
        }
        GitHubAPIManager.shared.starGist(gistId) { (error) in
            if let error = error {
                print(error)
                self.isStarred = nil
                let errorMessage: String?
                switch error {
                case BackendError.autuLost:
                    errorMessage = error.localizedDescription
                default:
                    errorMessage = "Sorry, your gist couldn't be starred. " + "Maybe GitHub is down or you don't have an internet connection"
                    break
                }
                if let errorMessage = errorMessage {
                    self.alertController = UIAlertController(title: "Could not star gist", message: errorMessage, preferredStyle: .alert)
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.alertController?.addAction(okAction)
                    self.present(self.alertController!, animated: true, completion: nil)
                    return
                }
            } else {
                self.isStarred = true
            }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
    
    func unstarThisGist() {
        guard let gistId = gist?.id else {
            return
        }
        GitHubAPIManager.shared.unstarGist(gistId) { (error) in
            if let error = error {
                print(error)
                self.isStarred = nil
                let errorMessage: String?
                switch error {
                case BackendError.autuLost:
                    errorMessage = error.localizedDescription
                default:
                    errorMessage = "Sorry, your gist couldn't be unstarred. " + "Maybe GitHub is down or you don't have an internet connection"
                    break
                }
                if let errorMessage = errorMessage {
                    self.alertController = UIAlertController(title: "Could not unstar gist", message: errorMessage, preferredStyle: .alert)
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.alertController?.addAction(okAction)
                    self.present(self.alertController!, animated: true, completion: nil)
                    return
                }
            } else {
                self.isStarred = false
            }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
    
}

