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
let userAuthenticated = false

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
        let onboardingWizardDataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(onboardingWizardSeen)
        }
        shell.requestOnboardingWizardEligibility(
            dataDependency: onboardingWizardDataDependency,
            viewPresenter: self)
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
            let termsAndConditionsDataDependency: ((Bool) -> Void) -> Void = { fulfill in
                fulfill(termsAndConditionsAccepted)
            }
            shell.requestTermsAndConditionsEligibility(
                dataDependency: termsAndConditionsDataDependency,
                viewPresenter: self)
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
        
        let shell = OnboardingClientShell()
        let rootViewPresenter = RootViewPresenter(window: window)
        
        let authenticationDataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(userAuthenticated)
        }
        shell.requestAuthenticationStatus(
            dataDependency: authenticationDataDependency,
            viewPresenter: rootViewPresenter)

        return true
    }
}

