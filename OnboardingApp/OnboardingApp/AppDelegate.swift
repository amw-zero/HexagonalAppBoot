//
//  AppDelegate.swift
//  OnboardingApp
//
//  Created by Alex Weisberger on 5/12/19.
//  Copyright © 2019 Alex Weisberger. All rights reserved.
//

import UIKit
import OnboardingClientCore

let termsAndConditionsAccepted = false
let onboardingWizardSeen = false
let userAuthenticated = true

struct RootViewPresenter: OnboardingViewPresenter {
    let window: UIWindow?
    
    func showTermsAndConditionsView(inShell shell: OnboardingClientShell) {
        let termsVC = TermsAndConditionsViewController()
        termsVC.onAcceptTermsAndConditions = {
            self.proceedToOnboardingWizard(inShell: shell)
        }
        window?.rootViewController = termsVC
    }
    
    func proceedToOnboardingWizard(inShell shell: OnboardingClientShell) {
        shell.requestOnboardingWizardEligibility()
    }
    
    func showOnboardingWizardView() {
        let onboardingWizardVC = OnboardingWizardViewController()
        onboardingWizardVC.onCompleteOnboardingWizard = {
            self.onDone()
        }
        window?.rootViewController = onboardingWizardVC
    }
    
    func showAuthenticationScreen(inShell shell: OnboardingClientShell) {
        let authenticationVC = AuthenticationViewController()
        authenticationVC.onAuthenticated = {
            shell.requestTermsAndConditionsEligibility()
        }
        window?.rootViewController = authenticationVC
    }
    
    func onDone() {
        window?.rootViewController = HomeViewController()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(
                authenticated: userAuthenticated,
                acceptedTermsAndConditions: termsAndConditionsAccepted,
                onboardingWizardShown: onboardingWizardSeen
            )
            fulfill(user)
        }
        let rootViewPresenter = RootViewPresenter(window: window)
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: rootViewPresenter
        )
        shell.requestAuthenticationStatus()

        return true
    }
}

