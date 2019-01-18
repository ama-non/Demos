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
    
    var restaurant: Restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        nameLabel.text = restaurant.name
        typeLabel.text = restaurant.type
        locationLabel.text = restaurant.location
        restaurantImageView.image = UIImage(named: restaurant.image)
    }
    
}
