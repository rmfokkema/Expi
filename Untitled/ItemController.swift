//
//  ItemController.swift
//  Untitled
//
//  Created by René Fokkema on 18/12/2021.
//

import Foundation
import UIKit

class ItemController: UIViewController {

	public var itemTitle: String
	@IBOutlet weak var itemLabel: UILabel!

	override var prefersStatusBarHidden: Bool { return true }
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }

	init(itemTitle: String) {
		self.itemTitle = itemTitle

		super.init(nibName: "Item", bundle: Bundle.main)
	}

	public func setItemTitle(_ title: String) {
		itemLabel.text = title
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		itemLabel.text = itemTitle
		setNeedsStatusBarAppearanceUpdate()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//navigationController?.navigationItem.leftBarButtonItem?.title = "Haha"
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
