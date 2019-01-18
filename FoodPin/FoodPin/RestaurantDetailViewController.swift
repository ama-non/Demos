//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/1/18.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    var restaurantName = ""
    var restaurantType = ""
    var restaurantLocation = ""
    var restaurantImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        nameLabel.text = restaurantName
        typeLabel.text = restaurantType
        locationLabel.text = restaurantLocation
        restaurantImageView.image = UIImage(named: restaurantImageName)
    }
    
}
