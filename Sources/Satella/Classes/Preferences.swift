import Cephei

final class Preferences {
    // MARK: Lifecycle
    
    private init() {
        preferences.register(defaults: [
            "enabled": true,
            "global": false,
            "observer": true,
            "price": false,
            "receipts": true,
            "sideloaded": false,
            "stealth": false
        ])
        
        preferences.register(&_isEnabled, default: true, forKey: "enabled")
        preferences.register(&_isGlobal, default: false, forKey: "globalInjection")
        preferences.register(&_isObserver, default: true, forKey: "observer")
        preferences.register(&_isPriceZero, default: true, forKey: "price")
        preferences.register(&_isReceipt, default: true, forKey: "receipts")
        preferences.register(&_isSideload, default: false, forKey: "sideloaded")
        preferences.register(&_isStealth, default: false, forKey: "stealth")
        
        // Convert ObjCBool to Bool
        
        isEnabled = _isEnabled.boolValue
        isReceipt = _isReceipt.boolValue
        isObserver = _isObserver.boolValue
        isPriceZero = _isPriceZero.boolValue
        isSideload = _isSideload.boolValue
        isStealth = _isStealth.boolValue
    }

    // MARK: Public
    
    public func shouldInit() -> Bool {
        if !isEnabled {
            return false
        }
        
        if !_isGlobal.boolValue {
            let altList = NSDictionary(contentsOfFile: "/var/mobile/Library/Preferences/emt.paisseon.satella.plist") as Dictionary?
            return (altList?["apps" as NSString]?.contains(Bundle.main.bundleIdentifier as Any) == true)
        }
        
        return true
    }

    // MARK: Internal

    static let shared: Preferences = .init()
    
    private(set) var isEnabled: Bool = true
    private(set) var isObserver: Bool = true
    private(set) var isPriceZero: Bool = false
    private(set) var isReceipt: Bool = true
    private(set) var isSideload: Bool = false
    private(set) var isStealth: Bool = false

    // MARK: Private

    private let preferences: HBPreferences = .init(identifier: "emt.paisseon.satella")
    
    private var _isEnabled: ObjCBool = true
    private var _isGlobal: ObjCBool = true
    private var _isObserver: ObjCBool = true
    private var _isPriceZero: ObjCBool = false
    private var _isReceipt: ObjCBool = true
    private var _isSideload: ObjCBool = false
    private var _isStealth: ObjCBool = false
}
