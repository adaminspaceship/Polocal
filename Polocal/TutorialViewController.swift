//
//  TutorialViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 19/10/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import paper_onboarding

class TutorialViewController: UIViewController {

	@IBOutlet var skipButton: UIButton!
	
	fileprivate let items = [
		OnboardingItemInfo(informationImage: UIImage(named: "1")!,
						   title: "",
						   description: "",
						   pageIcon: UIImage(named: "logo")!,
						   color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 0),
						   titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.systemFont(ofSize: 50), descriptionFont: UIFont.systemFont(ofSize: 20)),
		
		OnboardingItemInfo(informationImage: UIImage(named: "2")!,
						   title: "",
						   description: "",
						   pageIcon: UIImage(named: "logo")!,
						   color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 0),
						   titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.systemFont(ofSize: 50), descriptionFont: UIFont.systemFont(ofSize: 20)),
		]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupPaperOnboardingView()
		
		self.view.addSubview(skipButton)
		view.bringSubview(toFront: skipButton)
		
	}
	@IBAction func skipButtonTapped(_ sender: Any) {
		print("tapped")
	}
	@objc func buttonAction(sender: UIButton!) {
		print("Button tapped")
	}
	
	private func setupPaperOnboardingView() {
		let onboarding = PaperOnboarding()
		onboarding.delegate = self
		onboarding.dataSource = self
		onboarding.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(onboarding)
		
		// Add constraints
		for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
			let constraint = NSLayoutConstraint(item: onboarding,
												attribute: attribute,
												relatedBy: .equal,
												toItem: view,
												attribute: attribute,
												multiplier: 1,
												constant: 0)
			view.addConstraint(constraint)
		}
	}
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
	
	
    */
	
	extension TutorialViewController: PaperOnboardingDelegate {
		

		func onboardingDidTransitonToIndex(_: Int) {
		}
		
		func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
			//item.titleLabel?.backgroundColor = .redColor()
			//item.descriptionLabel?.backgroundColor = .redColor()
			//item.imageView = ...
		}
	}
	
	// MARK: PaperOnboardingDataSource
	
extension TutorialViewController: PaperOnboardingDataSource {
	
	func onboardingItem(at index: Int) -> OnboardingItemInfo {
		return items[index]
	}
	
	func onboardingItemsCount() -> Int {
		return 2
	}
	
	//    func onboardinPageItemRadius() -> CGFloat {
	//        return 2
	//    }
	//
	//    func onboardingPageItemSelectedRadius() -> CGFloat {
	//        return 10
	//    }
	//    func onboardingPageItemColor(at index: Int) -> UIColor {
	//        return [UIColor.white, UIColor.red, UIColor.green][index]
	//    }
}
