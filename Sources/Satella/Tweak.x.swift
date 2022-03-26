import Orion
import SatellaC
import StoreKit
import Cephei

struct Main     : HookGroup {}
struct Receipt  : HookGroup {}
struct Observer : HookGroup {}
struct Sideload : HookGroup {}

class TransactionHook: ClassHook<SKPaymentTransaction> {
	typealias Group = Main

	func transactionState() -> SKPaymentTransactionState {
		if target.original != nil {
			return .restored
		}
		
		return .purchased
	}
	
	func _setTransactionState(_ arg0: SKPaymentTransactionState) {
		if arg0 == .restored {
			orig._setTransactionState(arg0)
			return
		}
		
		orig._setTransactionState(.purchased)
	}
	
	func _setError(_ arg0: NSError?) {
		orig._setError(nil)
	}
	
	func matchingIdentifier() -> String {
		"satella-mId-\(Int.random(in: 1..<999999))"
	}
	
	func transactionIdentifier() -> String {
		"satella-tId-\(Int.random(in: 1..<999999))"
	}
	
	func _transactionIdentifier() -> String {
		"satella-_tId-\(Int.random(in: 1..<999999))"
	}
	
	func _setTransactionIdentifier(_ arg0: String) {
		orig._setTransactionIdentifier("satella-_tId-\(Int.random(in: 1..<999999))")
	}
	
	func transactionDate() -> NSDate {
		NSDate()
	}
	
	func _setTransactionDate(_ arg0: NSDate) {
		orig._setTransactionDate(NSDate())
	}
}

class QueueHook: ClassHook<SKPaymentQueue> {
	typealias Group = Main
	
	class func canMakePayments() -> Bool {
		true
	}
}

class RefreshHook: ClassHook<SKReceiptRefreshRequest> {
	typealias Group = Receipt
	
	func _wantsRevoked() -> Bool {
		false
	}
	
	func _wantsExpired() -> Bool {
		false
	}
}

class ObserverHook: ClassHook<SKPaymentQueue> {
	typealias Group = Observer
	
	func addTransactionObserver(_ arg0: SKPaymentTransactionObserver) {
		let tellaObserver      = SatellaObserver.shared
		tellaObserver.observer = arg0
		
		orig.addTransactionObserver(tellaObserver)
	}
}

class RequestHook: ClassHook<SKProductsRequest> {
	typealias Group = Sideload
	
	func setDelegate(_ arg0: SKProductsRequestDelegate) {
		let tellaDelegate      = SatellaDelegate.shared
		tellaDelegate.delegate = arg0
		
		orig.setDelegate(tellaDelegate)
	}
}

class VerifyHook: ClassHook<NSURL> {
	typealias Group = Main
	
	func initWithString(_ arg0: String) -> NSURL {
		if arg0.contains("itunes.apple.com/verifyReceipt") {
			return orig.initWithString("https://drm.cypwn.xyz/verifyReceipt")
		}
		
		return orig.initWithString(arg0)
	}
	
	class func URLWithString(_ arg0: String) -> NSURL {
		if arg0.contains("itunes.apple.com/verifyReceipt") {
			return orig.URLWithString("https://drm.cypwn.xyz/verifyReceipt")
		}
		
		return orig.URLWithString(arg0)
	}
}

class Satella: Tweak {
	required init() {
		if Preferences.shared.shouldInit() {
			Main().activate()
			
			if Preferences.shared.receipts.boolValue == true {
				Receipt().activate() // this is located in ReceiptHook.swift because it was large and ugly
			}
			
			if Preferences.shared.observer.boolValue == true {
				Observer().activate()
			}
			
			if Preferences.shared.sideloaded.boolValue == true {
				Sideload().activate()
			}
		}
	}
}