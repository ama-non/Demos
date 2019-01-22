//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/1/22.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet weak var closeButton: UIButton!
    
    var restaurant = Restaurant()

    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(named: restaurant.image)
        
        // Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        // Make the button invisible and move off the screen
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        // Make close button invisibale and move off the screen
        let moveUpTransform = CGAffineTransform(translationX: 0, y: -100)
        closeButton.transform = moveUpTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for index in 0...rateButtons.count-1 {
            UIView.animate(withDuration: 0.8, delay: 0.1 + 0.05 * Double(index), options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.5, options: [], animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
    }

}
