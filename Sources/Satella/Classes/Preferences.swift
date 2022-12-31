import Foundation

struct Preferences: Decodable {
    var apps: [String] = []
    var isEnabled: Bool = true
    var isGloballyInjected: Bool = true
    var isObserver: Bool = false
    var isPriceZero: Bool = false
    var isReceipt: Bool = false
    var isSideloaded: Bool = false
    var isStealth: Bool = false
    
    func shouldInject() -> Bool {
        guard isEnabled else {
            return false
        }
        
        if !isGloballyInjected {
            guard let bundleID: String = Bundle.main.bundleIdentifier else {
                return false
            }
            
            return apps.contains(bundleID)
        }
        
        return true
    }
    
    enum CodingKeys: String, CodingKey {
        case apps
        case isEnabled = "enabled"
        case isGloballyInjected = "globalInjection"
        case isObserver = "observer"
        case isPriceZero = "price"
        case isReceipt = "receipts"
        case isSideloaded = "sideloaded"
        case isStealth = "stealth"
    }
}
