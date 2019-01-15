//
//  MasterViewController.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit
import PINRemoteImage
import SafariServices
import Alamofire
import BRYXBanner

class MasterViewController: UITableViewController, LoginViewDelegate, SFSafariViewControllerDelegate {
    var safariViewController: SFSafariViewController?

    var detailViewController: DetailViewController? = nil
    var gists: [Gist] = []
    var nextPageURLString: String?
    var isLoading = false
    var dateFormatter = DateFormatter()
    var errorBanner: Banner?

    @IBOutlet weak var gistsSegmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        gists = []
        tableView.reloadData()
        loadGists(urlToLoad: nil)
        
        // only show addbutton for my gists
        if gistsSegmentedControl.selectedSegmentIndex == 2 {
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
            self.navigationItem.rightBarButtonItem = addButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        // add refresh control for pull to refresh
        if self.refreshControl == nil {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
            self.dateFormatter.dateStyle = .short
            self.dateFormatter.timeStyle = .long
        }
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Pull to refresh
    @objc
    func refresh(sender: Any) {
        GitHubAPIManager.shared.isLoadingOAuthToken = false
        nextPageURLString = nil // so it doesn't try to append the results
        GitHubAPIManager.shared.clearCache()
        loadInitialGists()
    }

    // MARK: - Creation
    @objc
    func insertNewObject(_ sender: Any) {
        let createVC = CreateGistViewController(nibName: nil, bundle: nil)
        
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GitHubAPIManager.shared.isLoadingOAuthToken {
             loadInitialGists()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let exsitingBanner = self.errorBanner {
            exsitingBanner.dismiss()
        }
        super.viewWillAppear(true)
    }
    
    func loadInitialGists() {
        isLoading = true
        
        GitHubAPIManager.shared.OAuthTokenCompletionHandler = { error in
            guard error == nil else {
                print(error!)
                self.isLoading = false
                switch error! {
                case BackendError.network(error: let innerError as NSError):
                    if innerError.domain != NSURLErrorDomain {
                        break
                    }
                    if innerError.code == NSURLErrorNotConnectedToInternet {
                        self.showNotConnectedBanner()
                        return
                    }
                default:
                    break
                }
                
                // something went wrong, try again
                self.showOAuthLoginView()
                return
            }
            if let _ = self.safariViewController {
                self.dismiss(animated: false, completion: {})
            }
            self.loadGists(urlToLoad: nil)
        }
        
        if !GitHubAPIManager.shared.hasOAuthToken() {
            showOAuthLoginView()
            return
        }
        
        loadGists(urlToLoad: nil)
        
    }
    
    func showOAuthLoginView() {
        GitHubAPIManager.shared.isLoadingOAuthToken = true
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            as? LoginViewController else {
            assert(false, "Misnamed view controller")
                return
        }
        loginVC.delegate = self
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func didTapLoginButton() {
        self.dismiss(animated: false) {
            guard let authURL = GitHubAPIManager.shared.URLToStartOAuth2Login() else {
                let error = BackendError.authCouldNot(reason: "Could not obtain an OAuth token")
                
                GitHubAPIManager.shared.OAuthTokenCompletionHandler?(error)
                return
            }
            self.safariViewController = SFSafariViewController(url: authURL)
            self.safariViewController?.delegate = self
            guard let webviewController = self.safariViewController else {
                return
            }
            self.present(webviewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Safari view controller Delegate
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        // Detect not being able to load the OAuth URL
        if !didLoadSuccessfully {
            controller.dismiss(animated: true, completion: nil)
        }
        GitHubAPIManager.shared.isAPIOnline { (isOnline) in
            if !isOnline {
                print("error: api offline")
            }
            let innerError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection or GitHub is offline"])
            let error = BackendError.network(error: innerError)
            
            GitHubAPIManager.shared.OAuthTokenCompletionHandler?(error)
        }
    }
    
    func loadGists(urlToLoad: String?) {
        self.isLoading = true
        
        let completionHandler: (Result<[Gist]>, String?) -> Void = { (result, nextPage) in
            self.isLoading = false
            self.nextPageURLString = nextPage
            
            // tell refresh control it can stop showing up now
            if self.refreshControl != nil, self.refreshControl!.isRefreshing {
                self.refreshControl?.endRefreshing()
            }
            
            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }
            
            if let fetchedGists = result.value {
                if urlToLoad == nil {
                    // empty out the gists because we're not loading another page
                    self.gists = []
                }
                self.gists += fetchedGists
            }
            
            // update "last updated" title for refresh control
            let now = Date()
            let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
            self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
            
            self.tableView.reloadData()
        }
        
        switch gistsSegmentedControl.selectedSegmentIndex {
        case 0:
            GitHubAPIManager.shared.fetchPublicGists(pageToLoad: urlToLoad, completionHandler: completionHandler)
        case 1:
            GitHubAPIManager.shared.fetchMyStarredGists(pageToLoad: urlToLoad, completionHandler: completionHandler)
        case 2:
            GitHubAPIManager.shared.fetchMyGists(pageToLoad: urlToLoad, completionHandler: completionHandler)
        default:
            print("got an index that I didn't expect for selectedSegmentIndex")
        }
    }
    
    func handleLoadGistsError(_ error: Error) {
        print(error)
        nextPageURLString = nil
        isLoading = false
        
        switch error {
        case BackendError.autuLost:
            self.showOAuthLoginView()
            return
        case BackendError.network(let innerError as NSError):
            // check the domain
            if innerError.domain != NSURLErrorDomain {
                break
            }
            // check the code
            if innerError.code == NSURLErrorNotConnectedToInternet {
                showNotConnectedBanner()
                return
            }
        default:
            break
        }
    }
    
    func showNotConnectedBanner() {
        // check for existing banner
        if let existingBanner = self.errorBanner {
            existingBanner.dismiss()
        }
        // show not connected banner error & tell em to try again when they do have a connection
        self.errorBanner = Banner(title: "No Internet Connection", subtitle: "Could not load gists" + " Try again when you're connected to the internet ", image: nil, backgroundColor: .red)
            self.errorBanner?.dismissesOnSwipe = true
            self.errorBanner?.show(duration: nil)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let gist = gists[indexPath.row]
                controller.gist = gist
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let gist = gists[indexPath.row]
        cell.textLabel?.text = gist.gistDescription
        cell.detailTextLabel?.text = gist.owner?.login
        
        // set cell.imageView to display image at gist.owner?.avatarURL
        if let url = gist.owner?.avatarURL {
            cell.imageView?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder.png"), completion: { (result) in
                if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                    cellToUpdate.setNeedsLayout()
                }
            })
        } else {
            cell.imageView?.image = UIImage(named: "palceholder.png")
        }
        
        if !isLoading {
            let rowsLoaded = gists.count
            let rowsRemaining = rowsLoaded - indexPath.row
            let rowsToLoadFromBottom = 5
            
            if rowsRemaining <= rowsToLoadFromBottom {
                if let nextPage = nextPageURLString {
                    self.loadGists(urlToLoad: nextPage)
                }
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // only allow editing my gists
        return gistsSegmentedControl.selectedSegmentIndex == 2
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gistToDelete = gists[indexPath.row]
            // remove from array of gists
            gists.remove(at: indexPath.row)
            // remove table view row
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // delete from API
            if let idToDelete = gistToDelete.id {
                
                GitHubAPIManager.shared.deleteGist(idToDelete) { (error) in
                    if let error = error {
                        print(error)
                        // Put it back
                        self.gists.insert(gistToDelete, at: indexPath.row)
                        tableView.insertRows(at: [indexPath], with: .right)
                        // tell them it didn;t work
                        let alertController = UIAlertController(title: "Could not delete gist", message: "Sorry, your gist couldn't be deleted. " + "Maybe GitHub is down or you don't have internet connection.", preferredStyle: .alert)
                        // add ok action
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

