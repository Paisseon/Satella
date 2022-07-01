import Cephei

class Preferences {
	static let shared = Preferences()
	
	private let preferences                = HBPreferences(identifier: "emt.paisseon.satella")
    
    // These vars are read from the tweak
    
	private(set) var enabled         = true
	private(set) var receipts        = false
	private(set) var observer        = false
	private(set) var sideloaded      = false
	private(set) var globalInjection = false
    
    // For some reason, Cephei uses ObjCBool instead of the standard Bool type
    
    private var enabledI: ObjCBool         = true
    private var receiptsI: ObjCBool        = false
    private var observerI: ObjCBool        = false
    private var sideloadedI: ObjCBool      = false
    private var globalInjectionI: ObjCBool = false
	
    // Cephei stuff. Extra features are disabled by default, just experiment because they break some apps and fix others.
    
	private init() {
		preferences.register(defaults: [
			"enabled"         : true,
			"receipts"        : false,
			"observer"        : false,
			"sideloaded"      : false,
			"globalInjection" : false,
		])
	
		preferences.register(_Bool: &enabledI,         default: true,  forKey: "enabled")
		preferences.register(_Bool: &receiptsI,        default: false, forKey: "receipts")
		preferences.register(_Bool: &observerI,        default: false, forKey: "observer")
		preferences.register(_Bool: &sideloadedI,      default: false, forKey: "sideloaded")
		preferences.register(_Bool: &globalInjectionI, default: false, forKey: "globalInjection")
        
        enabled         = enabledI.boolValue
        receipts        = receiptsI.boolValue
        observer        = observerI.boolValue
        sideloaded      = sideloadedI.boolValue
        globalInjection = globalInjectionI.boolValue
	}
    
    // Determine if Satella should be executed in this app. Refer to SatellaC/Tweak.m to check for user vs system apps.
	
	public func shouldInit() -> Bool {
		if !enabled {
			return false
		}
        
        // If global injection is disabled, check AltList for the bundle id
		
		if !globalInjection {
            let altList = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/emt.paisseon.satella.plist") as Dictionary?
			return (altList?["apps" as NSString]?.contains(Bundle.main.bundleIdentifier as Any) == true)
		}
		
		return true
	}
}
