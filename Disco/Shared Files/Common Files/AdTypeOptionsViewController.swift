import UIKit
import FLEX

class AdTypeOptionsViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFlexDebugRightButton()
    }
        
    @IBAction func choosingBanner(_ sender: Any) {
        BaseAdViewController.shared.adType = .Banner
        self.performSegue(withIdentifier: "goToBannerScenarios", sender: self)
    }

    @IBAction func choosingMRect(_ sender: Any) {
        BaseAdViewController.shared.adType = .MRectVideo
        self.performSegue(withIdentifier: "goToBannerScenarios", sender: self)
    }
    
    @IBAction func choosingLeaderboard(_ sender: Any) {
        BaseAdViewController.shared.adType = .Leaderboard
        self.performSegue(withIdentifier: "goToBannerScenarios", sender: self)
    }
}

extension UIViewController {
    func addFlexDebugRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gearIcon"), style: .plain, target: self, action: #selector(barButtonMethod(_:)))
    }
    
    @objc func barButtonMethod(_ sender: UIBarButtonItem) {
        FLEXManager.shared.showExplorer()
    }
}
