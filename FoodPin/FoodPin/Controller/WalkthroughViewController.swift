//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/2/2.
//  Copyright © 2019 Atom. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    // MARK: - Properties
    
     var walkthroughPageViewController: WalkthroughPageViewController?
    
    // MARK: - Outlets
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
        
        updateUI()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        // Update UI buttons
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
                
            default:
                break
            }
            
            pageControl.currentPage = index
        }
    }
    
    // MARK: - WalkthroughPageViewControllerDelegate methods
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }

}
