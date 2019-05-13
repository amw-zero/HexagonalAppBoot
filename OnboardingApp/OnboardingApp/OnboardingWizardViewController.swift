//
//  OnboardingWizardViewController.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/12/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit

class OnboardingWizardViewController: UIViewController {
    var onCompleteOnboardingWizard: () -> Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Complete Onboarding Wizard", for: .normal)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        button.addTarget(self, action: #selector(completeOnboardingWizard), for: .touchUpInside)
    }
    
    @objc func completeOnboardingWizard() {
        onCompleteOnboardingWizard()
    }
}
