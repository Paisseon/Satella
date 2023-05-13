import CoreFoundation
import Jinx

private let prefs: JinxPreferences = .init(for: "emt.paisseon.satella")

struct Preferences {
    static let apps: [String]           = prefs.get(for: "apps",               default: [String]())
    static let isEnabled: Bool          = prefs.get(for: "isEnabled",          default: true)
    static let isGloballyInjected: Bool = prefs.get(for: "isGloballyInjected", default: false)
    static let isObserver: Bool         = prefs.get(for: "isObserver",         default: false)
    static let isPriceZero: Bool        = prefs.get(for: "isPriceZero",        default: false)
    static let isReceipt: Bool          = prefs.get(for: "isReceipt",          default: false)
    static let isSideloaded: Bool       = prefs.get(for: "isSideloaded",       default: false)
    static let isStealth: Bool          = prefs.get(for: "isStealth",          default: false)
    
    static func shouldInject() -> Bool {
        guard isEnabled,
              let bundle: CFBundle = CFBundleGetMainBundle(),
              let bundleID: String = CFBundleGetIdentifier(bundle) as? String,
              !bundleID.hasPrefix("com.apple.")
        else {
            return false
        }
        
        if !isGloballyInjected {
            return apps.contains(bundleID)
        }
        
        return true
    }
}
