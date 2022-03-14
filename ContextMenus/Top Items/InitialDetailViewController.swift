/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Primary or initial detail view controller for the split view.
*/

import UIKit

class InitialDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

		//var detailViewManager: DetailViewManager?

//		if let splitViewController = view.window!.rootViewController as? UISplitViewController {
//			detailViewManager = DetailViewManager()
//			detailViewManager.splitViewController = splitViewController
//		}
        
		if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
			detailLabel.text = appName
		} else {
			if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
				detailLabel.text = appName
			}
		}
    }
    
}

