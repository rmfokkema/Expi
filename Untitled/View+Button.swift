//
//  View.swift
//  Untitled
//
//  Created by René Fokkema on 15/12/2021.
//

import UIKit

class View: UIView {

	var controller: ViewController?

	/*
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .random
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		backgroundColor = .random
	}
	 */

	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard motion == .motionShake else { return }

		if let timer = controller!.timer {
			switch timer.isValid {
				case true: timer.invalidate()
				case false: controller?.setBackgroundAnimationTimer()
			}
		}

		print("Shake it, baby!")
	}
}

class Button: UIButton {

	override var isHighlighted: Bool {
		didSet {
			alpha = isHighlighted ? 0.25 : 0.06
		}
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setColors()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setColors()
	}

	internal func setColors() {
		backgroundColor = .black
		alpha = 0.09
	}

}
