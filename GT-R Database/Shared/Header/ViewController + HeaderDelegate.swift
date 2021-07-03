import Foundation
import FirebaseAnalytics
import SafariServices

extension UIViewController: HeaderDelegate {
    func headerShouldHideOptionalElements() -> [HeaderElement] {
        switch self {
        case is ViewController: return [.BackButton, .Title, .ShareButton]
        case is VINSearchController: return []
        default: return [.ShareButton]
        }
    }
    
    func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleShareButton() {
        if let controller = self as? VINSearchController {
            controller.share()
        }
    }
    
    func handleTorqueGTButton() {
        if let url = URL(string: BaseURL.torqueGThome) {
            let webView = SFSafariViewController(url: url)
            self.present(webView, animated: true)
            Analytics.logEvent(AnalyticsEventViewItem,
                               parameters: [AnalyticsParameterItemName: "TorqueGT Website"])
        }
    }
    
    func handleGTRButton() {
        if let url = URL(string: BaseURL.gtrDatabaseHome) {
            let webView = SFSafariViewController(url: url)
            self.present(webView, animated: true)
            Analytics.logEvent(AnalyticsEventViewItem,
                               parameters: [AnalyticsParameterItemName: "TorqueGT Website"])
        }
    }
}
