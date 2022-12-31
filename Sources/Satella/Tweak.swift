import Foundation

struct Tweak {
    static let config: Config = .jinx
    
    static func ctor() {
        guard ProcessInfo.processInfo.arguments[0].hasPrefix("/var/containers/Bundle/Application"),
              Bundle.main.bundleIdentifier?.hasPrefix("com.apple.") != true,
              let data: Data = try? .init(contentsOf: URL(fileURLWithPath: "/var/mobile/Library/Preferences/emt.paisseon.satella.plist"))
        else {
            return
        }
        
        let prefs: Preferences = (try? PropertyListDecoder().decode(Preferences.self, from: data)) ?? .init()
        
        guard prefs.shouldInject() else {
            return
        }
        
        // SKPaymentQueue
        
        AddTransactionObserver().hook(onlyIf: prefs.isObserver)
        CanMakePayments().hook()
        
        // SKPaymentTransaction
        
        ErrorGetter().hook()
        MatchingIdentifier().hook()
        TransactionDate().hook()
        TransactionIdentifier().hook()
        TransactionReceipt().hook(onlyIf: prefs.isReceipt)
        TransactionState().hook()
        
        // SKProduct
        
        Price().hook(onlyIf: prefs.isPriceZero)
        
        // SKProductsRequest
        
        if #available(iOS 13, *) {
            SetDelegate().hook(onlyIf: prefs.isSideloaded)
        } else {
            SetDelegate12().hook(onlyIf: prefs.isSideloaded)
        }
        
        // URLSession
        
        DataTask().hook(onlyIf: prefs.isReceipt)
        
        // Functions
        
        DyldGetImageName().hook(onlyIf: prefs.isStealth)
        ObjcGetClass().hook(onlyIf: prefs.isStealth)
    }
}
