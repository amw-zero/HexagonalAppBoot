//
//  HomeViewController.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/17/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let homeLabel = UILabel(frame: .zero)
        homeLabel.text = "Home"
        view.addSubview(homeLabel)
        AutoLayout.activateConstraints(forViews: [homeLabel], [
            homeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
