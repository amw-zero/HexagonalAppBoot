//
//  OnboardingClientCore.swift
//  OnboardingClientCore
//
//  Created by Alex Weisberger on 5/6/19.
//

import Foundation

public protocol OnboardingViewPresenter {
    func showTermsAndConditionsView(inShell: OnboardingClientShell)
    func proceedToOnboardingWizard(inShell: OnboardingClientShell)
    func showOnboardingWizardView()
    func showAuthenticationScreen(inShell: OnboardingClientShell)
    func onDone()
}

public typealias BoolFunc = (Bool) -> Void

public struct User {
    let authenticated: Bool
    let acceptedTermsAndConditions: Bool
    let onboardingWizardShown: Bool
    
    public init(authenticated: Bool = false, acceptedTermsAndConditions: Bool = false, onboardingWizardShown: Bool = false) {
        self.authenticated = authenticated
        self.acceptedTermsAndConditions = acceptedTermsAndConditions
        self.onboardingWizardShown = onboardingWizardShown
    }
    
    static public func make() -> User {
        return .init(
            authenticated: false,
            acceptedTermsAndConditions: false,
            onboardingWizardShown: false
        )
    }
}

public class OnboardingClientShell: Equatable {
    public static func == (lhs: OnboardingClientShell, rhs: OnboardingClientShell) -> Bool {
        return lhs === rhs
    }
    
    let dataDependency: ((User) -> Void) -> Void
    let viewPresenter: OnboardingViewPresenter
    var user: User? = nil
    
    public init(
        dataDependency: @escaping ((User) -> Void) -> Void = { fulfill in fulfill(User.make()) },
        viewPresenter: OnboardingViewPresenter
    ) {
        self.dataDependency = dataDependency
        self.viewPresenter = viewPresenter
    }
    
    public func requestTermsAndConditionsEligibility() -> Void{
        executeAfterDependency {
            if let accepted = user?.acceptedTermsAndConditions, accepted {
                viewPresenter.proceedToOnboardingWizard(inShell: self)
            } else {
                viewPresenter.showTermsAndConditionsView(inShell: self)
            }
        }
    }
    public func acceptTermsAndConditions(viewPresenter: OnboardingViewPresenter) {
        viewPresenter.proceedToOnboardingWizard(inShell: self)
        
    }
    public func requestOnboardingWizardEligibility() -> Void {
        executeAfterDependency {
            if let wizardShown = user?.onboardingWizardShown, wizardShown {
                viewPresenter.onDone()
            } else {
                viewPresenter.showOnboardingWizardView()
            }
        }
    }
    public func requestAuthenticationStatus(inShell shell: OnboardingClientShell) -> Void {
        executeAfterDependency {
            if let userAuthenticated = user?.authenticated, userAuthenticated {
                shell.requestTermsAndConditionsEligibility()
            } else {
                viewPresenter.showAuthenticationScreen(inShell: self)
            }
        }
    }
    
    private func executeAfterDependency(callback: () -> Void) {
        if let _ = user {
            callback()
        } else {
            dataDependency { [weak self] user in
                guard let self = self else { return }
                self.user = user
                callback()
            }
        }
    }
}
