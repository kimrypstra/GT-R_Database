import Foundation

protocol HeaderDelegate {
    func handleBackButton()
    func handleShareButton()
    func handleTorqueGTButton()
    func headerShouldHideOptionalElements() -> [HeaderElement]
}
