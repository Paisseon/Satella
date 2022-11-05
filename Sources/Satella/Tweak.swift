import StoreKit

struct Tweak {
    static let config: Config = .jinx
    
    static func ctor() {
        let prefs: Preferences = .shared
        
        if !prefs.shouldInit() {
            return
        }
        
        // NSURL
        
        InitWithString().hook()
        URLWithString().hook()
        
        // SKPaymentQueue
        
        AddTransactionObserver().hook(onlyIf: prefs.isObserver)
        CanMakePayments().hook()
        
        // SKPaymentTransaction
        
        ErrorGetter().hook()
        MatchingIdentifier().hook()
        TransactionIdentifier().hook()
        TransactionReceipt().hook(onlyIf: prefs.isReceipt)
        TransactionState().hook()
        TransactionDate().hook()
        
        // SKProduct
        
        Price().hook(onlyIf: prefs.isPriceZero)
        
        // SKProductsRequest
        
        if #available(iOS 13, *) {
            SetDelegate().hook(onlyIf: prefs.isSideload)
        } else {
            SetDelegate12().hook(onlyIf: prefs.isSideload)
        }
        
        // Functions
        
        DyldGetImageName().hook(onlyIf: prefs.isStealth)
        ObjcGetClass().hook(onlyIf: prefs.isStealth)
    }
}
