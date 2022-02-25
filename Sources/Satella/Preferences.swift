import Cephei

class Preferences {
	static let shared = Preferences() // shared instance so we can check these values from the satella class
	
	private let preferences                    = HBPreferences(identifier: "emt.paisseon.satella")
	private(set) var enabled: ObjCBool         = true
	private(set) var receipts: ObjCBool        = false
	private(set) var observer: ObjCBool        = true
	private(set) var globalInjection: ObjCBool = false
	
	private init() { // various cephei stuff
		preferences.register(defaults: [
			"enabled"         : true,
			"receipts"        : false,
			"observer"        : true,
			"globalInjection" : false,
		])
	
		preferences.register(_Bool: &enabled, default: true, forKey: "enabled")
		preferences.register(_Bool: &receipts, default: false, forKey: "receipts")
		preferences.register(_Bool: &observer, default: true, forKey: "observer")
		preferences.register(_Bool: &globalInjection, default: false, forKey: "globalInjection")
	}
	
	public func shouldInit() -> Bool {
		let altList = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/emt.paisseon.satella.plist") as Dictionary? // get all enabled apps
		
		if !enabled.boolValue {
			return false // if satella is disabled
		}
		
		if !globalInjection.boolValue {
			if altList?["apps" as NSString]?.contains(Bundle.main.bundleIdentifier as Any) == true {
				return true // if global injection is disabled but the app is enabled
			}
			return false
		}
		
		return true // all clear
	}
}
