//
//  AuthenticationViewController.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/17/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    var onAuthenticated: () -> Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let usernameLabel = UILabel(frame: .zero)
        usernameLabel.text = "Username"
        
        let passwordLabel = UILabel(frame: .zero)
        passwordLabel.text = "Password"
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Login", for: .normal)
        saveButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        
        let subviews = [usernameLabel, passwordLabel, saveButton]
        subviews.forEach { view.addSubview($0) }
        AutoLayout.activateConstraints(forViews: subviews, [
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 14),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func authenticate() {
        onAuthenticated()
    }
}
