import Cephei

class Preferences {
	static let shared = Preferences()
	
	private let preferences                    = HBPreferences(identifier: "emt.paisseon.satella")
	private(set) var enabled        : ObjCBool = true
	private(set) var receipts       : ObjCBool = false
	private(set) var observer       : ObjCBool = true
	private(set) var sideloaded     : ObjCBool = false
	private(set) var globalInjection: ObjCBool = false
	
	private init() {
		preferences.register(defaults: [
			"enabled"         : true,
			"receipts"        : true,
			"observer"        : true,
			"sideloaded"      : true,
			"globalInjection" : false,
		])
	
		preferences.register(_Bool: &enabled, default: true, forKey: "enabled")
		preferences.register(_Bool: &receipts, default: true, forKey: "receipts")
		preferences.register(_Bool: &observer, default: true, forKey: "observer")
		preferences.register(_Bool: &sideloaded, default: true, forKey: "sideloaded")
		preferences.register(_Bool: &globalInjection, default: false, forKey: "globalInjection")
	}
	
	public func shouldInit() -> Bool {
		let altList = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/emt.paisseon.satella.plist") as Dictionary?
		
		if !enabled.boolValue {
			return false
		}
		
		if !globalInjection.boolValue {
			if altList?["apps" as NSString]?.contains(Bundle.main.bundleIdentifier as Any) == true {
				return true
			}
			return false
		}
		
		return true
	}
}
