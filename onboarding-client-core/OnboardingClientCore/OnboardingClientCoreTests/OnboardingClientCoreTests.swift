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
    var onboardingWizardShell: OnboardingClientShell = OnboardingClientShell()
    var showedOnboardingWizard = false
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
    func onDone() {
        onDoneCalled = true
    }
}

class OnboardingClientCoreTests: XCTestCase {
    func testTermsAndConditionsShowsWhenNotAccepted() {
        let dataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(false)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell()
        shell.requestTermsAndConditionsEligibility(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter)
        XCTAssertTrue(viewPresenter.termsAndConditionsViewWasShown)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testTermsAndConditionsWhenAccepted() {
        let dataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(true)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell()
        shell.requestTermsAndConditionsEligibility(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter)
        XCTAssertTrue(viewPresenter.proceededToOnboardingWizard)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testAcceptingTermsAndConditions() {
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell()
        shell.acceptTermsAndConditions(viewPresenter: viewPresenter)
        
        XCTAssertTrue(viewPresenter.proceededToOnboardingWizard)
        XCTAssertEqual(viewPresenter.onboardingWizardShell, shell)
    }
    func testOnboardingWizardShownWhenHasNotBeenSeen() {
        let dataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(false)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell()
        shell.requestOnboardingWizardEligibility(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter)
        XCTAssertTrue(viewPresenter.showedOnboardingWizard)
    }
    func testOnboardingWizardShownWhenHasBeenSeen() {
        let dataDependency: ((Bool) -> Void) -> Void = { fulfill in
            fulfill(true)
        }
        let viewPresenter = TestOnboardingViewPresenter()
        let shell = OnboardingClientShell()
        shell.requestOnboardingWizardEligibility(
            dataDependency: dataDependency,
            viewPresenter: viewPresenter)
        XCTAssertTrue(viewPresenter.onDoneCalled)
    }
}
