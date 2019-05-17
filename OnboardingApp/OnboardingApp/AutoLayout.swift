//
//  AutoLayout.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/17/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit

struct AutoLayout {
    static func activateConstraints(forViews views: [UIView], _ constraints: [NSLayoutConstraint]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(constraints)
    }
}
