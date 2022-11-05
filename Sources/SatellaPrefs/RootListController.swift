import Cephei
import CepheiPrefs
import UIKit

class RootListController: HBRootListController {
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(respring)
        )
    }
	
    @objc func respring() {
        if #available(iOS 13, *) {
            let blurView: UIVisualEffectView = .init(
                effect: UIBlurEffect(style: .systemChromeMaterial)
            )
            
            blurView.frame = UIScreen.main.bounds
            blurView.alpha = 0.0
            
            view.addSubview(blurView)
            
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    blurView.alpha = 1.0
                }
            ) { _ in
                HBRespringController.respringAndReturn(
                    to: URL(string: "prefs:root=Satella")
                )
            }
        } else {
            HBRespringController.respringAndReturn(
                to: URL(string: "prefs:root=Satella")
            )
        }
    }
}
