//
//  AboutViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit
import MessageUI
import Firebase

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var topBannerBackgroundView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var introTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //UITextView.appearance().linkTextAttributes = [.foregroundColor: UIColor.black]
        
        introTextView.tintColor = .black
        
        let attributes = [NSAttributedString.Key.underlineStyle : (NSUnderlineStyle.thick.rawValue | NSUnderlineStyle.byWord.rawValue)]
        var attributedString = NSMutableAttributedString(attributedString: introTextView.attributedText)
        attributedString.addAttributes(attributes, range: NSRange(location: 13, length: 16))
        
        introTextView.attributedText = attributedString
        
        //let attributedString = NSAttributedString(string: introTextView.attributedText.string, attributes: attributes)
        
        //introTextView.attributedText = attributedString
        
        //UITextView.appearance().linkTextAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.byWord]

    }
    
    override func viewDidLayoutSubviews() {
        let bannerTopColour = UIColor(displayP3Red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        let bannerBottomColour = UIColor(displayP3Red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        let gradient = CAGradientLayer()

        gradient.frame = topBannerBackgroundView.bounds
        gradient.colors = [bannerTopColour.cgColor, bannerBottomColour.cgColor]

        topBannerBackgroundView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "About Screen"])
    }
    
    @IBAction func didTapFacebookButton(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/GTRRegistry") {
            UIApplication.shared.open(url)
        } else {
            print("Unable to make Facebook url")
        }
    }
    
    @IBAction func didTapBaseLegButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://baseleg.com.au")!)
    }
    
    @IBAction func didTapWebButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.gtr-registry.com")!)
    }
    
    @IBAction func didTapContactButton(_ sender: Any) {
        // Modify following variables with your text / recipient
        let recipientEmail = "gtrregistry1@gmail.com"
        let subject = "GT-R Database Enquiry"
        let body = ""
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func didTapExitButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
