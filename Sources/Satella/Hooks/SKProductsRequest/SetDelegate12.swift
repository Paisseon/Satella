import Jinx
import StoreKit

struct SetDelegate12: Hook {
    typealias T = @convention(c) (
        SKProductsRequest,
        Selector,
        SKProductsRequestDelegate
    ) -> Void

    let `class`: AnyClass? = SKProductsRequest.self
    let selector: Selector = sel_registerName("setDelegate:")
    let replacement: T = { target, cmd, delegate in
        let orig: T = PowPow.orig(SetDelegate12.self)!
        let tella: SatellaDelegate = .shared
        
        tella.delegates.append(delegate)
        orig(target, cmd, tella)
    }
}
