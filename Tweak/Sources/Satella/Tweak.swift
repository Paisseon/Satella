import Jinx

struct Tweak {
    static func ctor() {
        guard CommandLine.arguments[0].hasPrefix("/var/containers/Bundle/Application"),
              Preferences.shouldInject()
        else {
            return
        }
        
        CanPayHook().hook()
        TransactionHook().hook()
        
        if Preferences.isPriceZero { ProductHook().hook() }
        if Preferences.isObserver { ObserverHook().hook() }
        if Preferences.isSideloaded { DelegateHook().hook() }
        if Preferences.isStealth { DyldHook().hook() }
        
        if Preferences.isReceipt {
            ReceiptHook().hook()
            URLHook().hook()
        }
    }
}

@_cdecl("jinx_entry")
func jinxEntry() {
    Tweak.ctor()
}
