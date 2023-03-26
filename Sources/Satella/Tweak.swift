import Jinx

struct Tweak {
    static func ctor() {
        let prefs: Preferences = .shared
        
        guard prefs.shouldInject() else {
            return
        }
        
        CanPayHook().hook()
        TransactionHook().hook()
        
        if prefs.isPriceZero { ProductHook().hook() }
        if prefs.isSideloaded { DelegateHook().hook() }
        if prefs.isObserver { ObserverHook().hook() }
        
        if prefs.isReceipt {
            ReceiptHook().hook()
            URLHook().hook()
        }
    }
}

@_cdecl("jinx_entry")
func jinx_entry() {
    Tweak.ctor()
}
