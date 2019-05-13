//
//  ViewController.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/12/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    var onAcceptTermsAndConditions: () -> Void = { }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept Terms And Conditions", for: .normal)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        button.addTarget(self, action: #selector(acceptTermsAndConditions), for: .touchUpInside)
    }
    
    @objc func acceptTermsAndConditions() {
        onAcceptTermsAndConditions()
    }
}

