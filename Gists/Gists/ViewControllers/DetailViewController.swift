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
            let url = file.details.url
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.title = file.name
            
            self.navigationController?.pushViewController(safariViewController, animated: true)
        default:
            break
    }
    
    func fetchStarredStatus() {
        guard let gistedID = gist?.id else {
            return
        }
        GitHubAPIManager.shared.isGistStarred(gistedID) { (result) in
            guard result.error == nil else {
                print(result.error!)
                return
            }
            if let status = result.value, self.isStarred == nil {
                // just got it
                self.isStarred = status
                self.tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            }
        }
    }
}

