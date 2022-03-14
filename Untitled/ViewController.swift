	//
	//  ViewController.swift
	//  Untitled
	//
	//  Created by René Fokkema on 15/12/2021.
	//

import UIKit
import AVFoundation

class ViewController: UIViewController {

	@IBOutlet weak var timerLabel: UILabel!

	var waitTime = Double.random(in: 1...60)
	var timer: Timer!
	var timerStartTime: Double!
	var player: AVAudioPlayer?
	var url: URL?

	private enum AnimationType {
		case colors
		case location
	}

	private var animationType: AnimationType = .colors
		//private var buttons = [UIButton]()
	private var currentButton: UIButton?
	private let activityIndicator = UIActivityIndicatorView()
	@IBOutlet weak var gradientView: UIView!
	private var glow = CAGradientLayer()
	private var oldGlowColors = [CGColor]()
	private var newGlowColors = [CGColor]()
	private var oldGlowPoint: CGPoint?
	private var newGlowPoint: CGPoint?
	private var itemController: ItemController?
	@IBOutlet private weak var projectLabel: UILabel!
	private var isPresentingModal: Bool = false
	override var prefersStatusBarHidden: Bool { return true }
	override var prefersHomeIndicatorAutoHidden: Bool { return true }
	private lazy var contextMenuStoryBoard = UIStoryboard(name: "ContextMenus", bundle: nil)
	private lazy var contextMenuViewController = contextMenuStoryBoard.instantiateInitialViewController()

	private var didLayoutSubviews: Bool = false

	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard motion == .motionShake else { return }
		print("\n Shake it! \n")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		(view as! View).controller = self

		if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
			projectLabel.text = appName
		} else {
			if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
				projectLabel.text = appName
			}
		}

		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(presentContextMenus))
		swipeUp.direction = .up
		view.addGestureRecognizer(swipeUp)

		/*
		 activityIndicator.hidesWhenStopped = true
		 activityIndicator.style = .large
		 activityIndicator.color = .random
		 activityIndicator.isHidden = true
		 */

		navigationController!.modalPresentationStyle = .fullScreen

		self.makeExpiGrid(w: Int.random(in: 1...5), h: Int.random(in: 1...5))
		self.setupAudioTimer()

		view.bringSubviewToFront(timerLabel)
	}

	internal func makeExpiGrid(w: Int, h: Int) {

		let width = Int(view.bounds.width) / w
		let height = Int(view.bounds.height) / h

		var dx = 0
		var dy = 0
		var dw = 0
		var dh = 0

		for x in 0...w-1 {

			for y in 0...h-1 {

				dx = (x == 0)				? -1 : 0
				dy = (y == 0)				? -1 : 0
				dw = (x == 0 || x == w-1)	? 1 : 0
				dh = (y == 0 || y == h-1)	? 1 : 0

					// let frame = CGRect(x: CGFloat(x * Int(width) + dx ), y: CGFloat(y * Int(height) + dy ), width: width + CGFloat(dw), height: height + CGFloat(dh))
				let frame = CGRect(x: x * width + dx, y: y * height + dy, width: width + dw, height: height + dh)
				let button = Button(frame: frame)

				button.setTitle("\(x).\(y)", for: .normal)
				button.accessibilityIdentifier = "\(x).\(y)"

					// button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
				button.addTarget(self, action: #selector(buttonRepeat), for: .touchDownRepeat)

					// view.insertSubview(button, at: 1)
				view.addSubview(button)
			}
		}


	}

	internal func setupAudioTimer() {

		let track = Int.random(in: 1...3)

		var name = ""
		switch (track) {
		case 1: name = "Wish"
		case 2: name = "Away"
		case 3: name = "Grande"
		case 4: name = "Enough"
		default: ()
		}

		self.url = Bundle.main.url(forResource: name, withExtension: "m4a")

		guard self.url != nil else { print("File not found..."); return }

		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback, mode: .default)
			try audioSession.setActive(true)
		} catch { print(error.localizedDescription) }

		_ = Timer.scheduledTimer(withTimeInterval: self.waitTime, repeats: false, block: { _ in
			do {
				self.player = try AVAudioPlayer(contentsOf: self.url!, fileTypeHint: AVFileType.m4a.rawValue)
				self.player?.prepareToPlay()
				self.player?.play()

				  print("Playing: '\(name)'")
			} catch let error {
				print(error.localizedDescription)
			}
		})

		let precision = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
			guard self.waitTime > 0 else {
				return timer.invalidate()
			}

			self.timerLabel.text = String(Int(self.waitTime.rounded()))
			// print(String(self.waitTime))
			self.waitTime -= timer.timeInterval
		})
		precision.tolerance = 0.0

		UIView.animate(withDuration: self.waitTime, animations: {
			self.timerLabel.alpha = 0
		}, completion: { _ in
			self.timerLabel.isHidden = true
		})
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}

	@objc func buttonRepeat(_ sender: UIButton, forEvent event: UIEvent) {
		sender.backgroundColor = .random.withAlphaComponent(0.25)
	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

		guard !didLayoutSubviews else { return }

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

		setBackgroundAnimationTimer()

		didLayoutSubviews = true
	}

	@objc func setBackgroundAnimationTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 9.0, repeats: true, block: { _ in

			if (self.animationType == .colors) {

				let a1 = CABasicAnimation(keyPath: "colors")
				a1.fromValue = self.oldGlowColors
				a1.toValue = self.newGlowColors
				a1.duration = 7.0
				self.glow.add(a1, forKey: nil)
				self.oldGlowColors = self.newGlowColors
				self.newGlowColors = [UIColor.random.cgColor, UIColor.random.cgColor]

				self.animationType = .location
			} else {

				let a2 = CABasicAnimation(keyPath: "startPoint")
				a2.fromValue = self.oldGlowPoint
				a2.toValue = self.newGlowPoint
				a2.duration = 3.0
				self.glow.add(a2, forKey: nil)
				self.oldGlowPoint = self.newGlowPoint
				self.newGlowPoint = CGPoint(x: Double.random(in: 0...0.9), y: Double.random(in: 0...0.9))

				self.animationType = .colors
			}
		})
	}

	@objc private func presentContextMenus() {
		guard timer!.isValid else { return }

		if let vc = contextMenuViewController {
			navigationController?.present(vc, animated: true, completion: nil)
		}
	}
}

extension UIColor { static var random: UIColor { return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0) } }
