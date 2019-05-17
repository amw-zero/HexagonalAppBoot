//
//  OnboardingClientCoreTests.swift
//  OnboardingClientCoreTests
//
//  Created by Alex Weisberger on 5/6/19.
//

import XCTest
@testable import OnboardingClientCore


class TestOnboardingViewPresenter: OnboardingViewPresenter {
    var termsAndConditionsViewWasShown = false
    var proceededToOnboardingWizard = false
    var onboardingWizardShell: OnboardingClientShell?
    var showedOnboardingWizard = false
    var showedAuthenticationScreen = false
    var onDoneCalled = false
    
    func showTermsAndConditionsView(inShell shell: OnboardingClientShell) {
        termsAndConditionsViewWasShown = true
        onboardingWizardShell = shell
    }
    func proceedToOnboardingWizard(inShell shell: OnboardingClientShell) {
        proceededToOnboardingWizard = true
        onboardingWizardShell = shell
    }
    func showOnboardingWizardView() {
        showedOnboardingWizard = true
    }
    func showAuthenticationScreen(inShell shell: OnboardingClientShell) {
        showedAuthenticationScreen = true
        onboardingWizardShell = shell
    }
    func onDone() {
        onDoneCalled = true
    }
}

class OnboardingClientCoreTests: XCTestCase {
    func testTermsAndConditionsShowsWhenNotAccepted() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(acceptedTermsAndConditions: false)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        shell.requestTermsAndConditionsEligibility()
        
        XCTAssertTrue(viewPresenter.termsAndConditionsViewWasShown)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testTermsAndConditionsWhenAccepted() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(acceptedTermsAndConditions: true)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        
        shell.requestTermsAndConditionsEligibility()

        XCTAssertTrue(viewPresenter.proceededToOnboardingWizard)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testAcceptingTermsAndConditions() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User()
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        shell.acceptTermsAndConditions(viewPresenter: viewPresenter)
        
        XCTAssertTrue(viewPresenter.proceededToOnboardingWizard)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testOnboardingWizardShownWhenHasNotBeenSeen() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(onboardingWizardShown: false)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        shell.requestOnboardingWizardEligibility()
        
        XCTAssertTrue(viewPresenter.showedOnboardingWizard)
    }
    func testHomeScreenShownWhenHasBeenSeen() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(onboardingWizardShown: true)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        shell.requestOnboardingWizardEligibility()
        
        XCTAssertTrue(viewPresenter.onDoneCalled)
    }
    func testAuthenticationScreenShownWhenNotLoggedIn() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(authenticated: false)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        
        shell.requestAuthenticationStatus(inShell: shell)
        
        XCTAssertTrue(viewPresenter.showedAuthenticationScreen)
        XCTAssertEqual(shell, viewPresenter.onboardingWizardShell)
    }
    func testStartingAtTermsAndConditionsWhenUserIsLoggedIn() {
        let dataDependency: ((User) -> Void) -> Void = { fulfill in
            let user = User(authenticated: true)
            fulfill(user)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter
        )
        
        shell.requestAuthenticationStatus(inShell: shell)
        
        XCTAssertTrue(viewPresenter.termsAndConditionsViewWasShown)
        XCTAssertEqual(shell, viewPresenter.onboardingWizardShell)
    }
}
