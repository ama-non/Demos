//
//  LoginViewController.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/9.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func didTapLoginButton()
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewDelegate?

    @IBAction func tappedLoginButton(_ sender: Any) {
        delegate?.didTapLoginButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
