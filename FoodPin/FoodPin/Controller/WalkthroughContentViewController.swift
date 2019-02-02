//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/2/2.
//  Copyright © 2019 Atom. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: - Properties
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }

}
