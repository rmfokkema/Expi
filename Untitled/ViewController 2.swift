	//
	//  ViewController.swift
	//  Untitled
	//
	//  Created by René Fokkema on 15/12/2021.
	//

import UIKit

class ViewController: UIViewController {

	private enum AnimationType {
		case colors
		case location
	}

	private var animationType: AnimationType = .colors
	private var buttons = [UIButton]()
	private var currentButton: UIButton?
	private let activityIndicator = UIActivityIndicatorView()

	@IBOutlet weak var gradientView: UIView!

	private var glow = CAGradientLayer()

	private var oldGlowColors = [CGColor]()
	private var newGlowColors = [CGColor]()
	private var oldGlowPoint: CGPoint?
	private var newGlowPoint: CGPoint?

	private var itemController: ItemController?

	public var timer: Timer?

	// private var statusBarHidden: Bool = true
	override var prefersStatusBarHidden: Bool { return true }
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
	override var prefersHomeIndicatorAutoHidden: Bool { return true }

	override func viewDidLoad() {
		super.viewDidLoad()

		print("\nMain view loaded.\n")

		(view as! View).controller = self

		activityIndicator.hidesWhenStopped = true
		activityIndicator.style = .large
		activityIndicator.color = .random
		activityIndicator.isHidden = true

		// navigationController?.childForStatusBarHidden = self
	}

//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//
//		print("Did appear.")
//
//		//self.statusBarHidden = true
//		//setNeedsStatusBarAppearanceUpdate()
//	}

	@IBAction func buttonRelease(_ sender: UIButton, forEvent event: UIEvent) {
//		var config = UIButton.Configuration.filled()
//		config.showsActivityIndicator = true
//		sender.configuration = config
		sender.backgroundColor = UIColor.black.withAlphaComponent(0.05)
		//print("\(#function) [\(#line):\(#column)] \(#file) \(event)")

		itemController = ItemController(itemTitle: sender.accessibilityIdentifier!)
		navigationController?.isNavigationBarHidden = false
		navigationController?.pushViewController(itemController!, animated: true)
//		if event.phase == .ended && sender == currentButton {
//			print("Knop nummer \(sender.accessibilityIdentifier) is binnen...!")
//			currentButton = nil
//		}
//		sender.layer.cornerRadius = 0.0

		// print("You just pressed button", sender.accessibilityIdentifier!, "my man.")
	}

	@IBAction func buttonPressed(_ sender: UIButton, forEvent event: UIEvent) {
		currentButton = sender
		sender.backgroundColor = .black.withAlphaComponent(0.15)
	}
	
	@IBAction func buttonRepeat(_ sender: UIButton, forEvent event: UIEvent) {
		sender.backgroundColor = .random.withAlphaComponent(0.25)
	}



	// @objc func setBackgroundColor() { for button in buttons { button.backgroundColor = .random } }

	override func viewDidLayoutSubviews() {
		for item in view.subviews {
			if let id = item.accessibilityIdentifier {
				// print("Done:", id)
				buttons.append((item as! UIButton))
			}
		}

		glow.type = .radial
		glow.colors = [UIColor.random.cgColor, UIColor.random.cgColor]
		glow.frame = gradientView.frame
		glow.startPoint = CGPoint(x: Double.random(in: 0...1.5), y: Double.random(in: 0...1.5))
		glow.endPoint = CGPoint(x: -0.5, y: -0.3)
		gradientView.layer.addSublayer(glow)

		self.oldGlowColors = self.glow.colors as! [CGColor]
		self.newGlowColors = [UIColor.random.cgColor, UIColor.random.cgColor]

		self.oldGlowPoint = self.glow.startPoint
		self.newGlowPoint = CGPoint(x: Double.random(in: 0...0.7), y: Double.random(in: 0...0.7))

		timer = Timer.scheduledTimer(withTimeInterval: 9.0, repeats: true, block: { _ in

			if (self.animationType == .colors) {

			let a1 = CABasicAnimation(keyPath: "colors")
			a1.fromValue = self.oldGlowColors
			a1.toValue = self.newGlowColors
			a1.duration = 7.0

//			print("Colors! From: \(String(describing: a1.fromValue!)) to: \(String(describing: a1.toValue!))")
			self.glow.add(a1, forKey: nil)

			self.oldGlowColors = self.newGlowColors
			self.newGlowColors = [UIColor.random.cgColor, UIColor.random.cgColor]

//				print("Colors done!")

				// self.animationType = .location

			} else {

			let a2 = CABasicAnimation(keyPath: "startPoint")
			a2.fromValue = self.oldGlowPoint
			a2.toValue = self.newGlowPoint
			a2.duration = 3.0
//			print("Location! From: \(a2.fromValue!) to: \(a2.toValue!)")
			self.glow.add(a2, forKey: nil)
				//
			self.oldGlowPoint = self.newGlowPoint
			self.newGlowPoint = CGPoint(x: Double.random(in: 0...0.9), y: Double.random(in: 0...0.9))

//				print("Locazione done! xxx")

				// self.animationType = .colors

			}

		})
	}
}

extension UIColor {
	static var	random: UIColor {
		return UIColor(red: .random(in: 0...1),
					   green: .random(in: 0...1),
					   blue: .random(in: 0...1),
					   alpha: 1.0)
	}
}

extension UIEvent: Introspectable {}

protocol Introspectable: CustomDebugStringConvertible {}
extension Introspectable {
	var debugDescription: String {
		var output = "\n"
		for child in Mirror(reflecting: self).children {
			output += (child.label ?? "") + ": " + String(describing: child.value) + "\n\n"
		}
		return output + "Debug!!!\n"
	}
}


