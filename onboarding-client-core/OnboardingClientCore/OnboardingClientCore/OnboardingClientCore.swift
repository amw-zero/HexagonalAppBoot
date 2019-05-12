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
    func onDone()
}

public typealias BoolFunc = (Bool) -> Void

public class OnboardingClientShell: Equatable {
    public static func == (lhs: OnboardingClientShell, rhs: OnboardingClientShell) -> Bool {
        return lhs === rhs
    }
    
    public init() {
    }
    
    public func requestTermsAndConditionsEligibility(dataDependency: (BoolFunc) -> Void, viewPresenter: OnboardingViewPresenter) -> Void{
        dataDependency { termsAccepted in
            if termsAccepted {
                viewPresenter.proceedToOnboardingWizard(inShell: self)
            } else {
                viewPresenter.showTermsAndConditionsView(inShell: self)
            }
        }
    }
    public func acceptTermsAndConditions(viewPresenter: OnboardingViewPresenter) {
        viewPresenter.proceedToOnboardingWizard(inShell: self)
        
    }
    public func requestOnboardingWizardEligibility(dataDependency: (BoolFunc) -> Void, viewPresenter: OnboardingViewPresenter) -> Void {
        dataDependency { onboardingWizardShown in
            if onboardingWizardShown {
                viewPresenter.onDone()
            } else {
                viewPresenter.showOnboardingWizardView()
            }
        }
    }
}
