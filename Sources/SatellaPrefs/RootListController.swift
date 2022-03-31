import CepheiPrefs
import Cephei
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
		
		let appearanceSettings = HBAppearanceSettings()
		appearanceSettings.tintColor = UIColor(red: 0.4, green: 0, blue: 0.4, alpha: 1)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(respring))
	}
	
	@objc func respring() {
		if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib") {
			HBRespringController.respringAndReturn(to: URL(string: "prefs:root=Tweaks&path=Satella"))
		} else {
			HBRespringController.respringAndReturn(to: URL(string: "prefs:root=Satella"))
		}
	}
}