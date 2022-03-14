/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller used for displaying a custom context menu for WKWebView.
*/

import UIKit

class URLPreviewViewController: UIViewController {

    var url: URL!
    @IBOutlet var linkDomainLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!

	// Could not read serialized diagnostics file: error("Invalid diagnostics signature")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkDomainLabel.text = url.host
        linkLabel.text = url.absoluteString
    }
    
}
