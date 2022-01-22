import Orion
import SatellaC
import StoreKit
import Cephei

// groups to enable/disable features on init (see class Satella) instead of requiring a conditional every time
struct MainGroup: HookGroup {}
struct ReceiptGroup: HookGroup {}
struct ObserverGroup: HookGroup {}

class TransactionHook: ClassHook<SKPaymentTransaction> {
	typealias Group = MainGroup

	func transactionState() -> SKPaymentTransactionState {
		.purchased // self explanatory
	}
	
	func _setTransactionState(_ arg0: SKPaymentTransactionState) {
		orig._setTransactionState(.purchased) // iOS 14 support
	}
	
	func _setError(_ arg0: NSError?) {
		orig._setError(nil) // ignore any errors
	}
	
	// ⬇️ these prevent a really annoying crash without requiring xpc dictionary conversions and stufffff
	
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
}

class ReceiptHook: ClassHook<SKPaymentTransaction> {
	typealias Group = ReceiptGroup
	
	func transactionReceipt() -> Data? {
		let now:Int64 = Int64(Date().timeIntervalSince1970) * 1000 // get time since epoch in ms
		let bvrs = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String // get the app version
		let receiptId = Int.random(in: 1..<23092029) // generate random number
		let vendorId = UIDevice.current.identifierForVendor?.uuidString // get app uuid
		let bundleId = Bundle.main.bundleIdentifier // get app bundle id
		
		let purchaseInfo = "{\n\t\"original-purchase-date-pst\" = \"2021-07-15 04:29:00 America/Los_Angeles\";\n\t\"purchase-date-ms\" = \"\(String(describing: now))\";\n\t\"unique-identifier\" = \"V2hlcmUgYXJlIHRoZSBrbml2ZXMuIC0gQ2hhcmEu\";\n\t\"original-transaction-id\" = \"440000267115041\";\n\t\"bvrs\" = \"\(String(describing: bvrs))\";\n\t\"app-item-id\" = \"1106936921\";\n\t\"transaction-id\" = \"\(String(describing: receiptId))\";\n\t\"quantity\" = \"1\";\n\t\"original-purchase-date-ms\" = \"\(String(describing: now))\";\n\t\"unique-vendor-identifier\" = \"\(String(describing: vendorId))\";\n\t\"item-id\" = \"1114015840\";\n\t\"version-external-identifier\" = \"07151129\";\n\t\"product-id\" = \"\(String(describing: bundleId)).satella\";\n\t\"purchase-date\" = \"2021-07-15 11:29:00 Etc/GMT\";\n\t\"original-purchase-date\" = \"2021-07-15 11:29:00 Etc/GMT\";\n\t\"bid\" = \"\(String(describing: bundleId))\";\n\t\"purchase-date-pst\" = \"2021-07-15 04:29:00 America/Los_Angeles\";\n}" // template receipt with various stuff
		
		let purchaseData = purchaseInfo.data(using: .utf8) // convert to data
		var purchaseB64: String? = nil
		if let purchaseData = purchaseData {
			purchaseB64 = String(data: purchaseData, encoding: .utf8)
		} // back into string with base64 encoding
		
		let fullReceipt = "{\n\t\"signature\" = \"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\";\n\t\"purchase-info\" = \"\(String(describing: purchaseB64))\";\n\t\"pod\" = \"44\";\n\t\"signing-status\" = \"0\";\n}" // the full receipt with our hacked purchase info and a valid signature
		
		guard let finalReceipt = fullReceipt.data(using: .utf8) else {
			return nil
		} // convert base64 into data for the final receipt
		
		return finalReceipt
	}
}

class QueueHook: ClassHook<SKPaymentQueue> {
	typealias Group = MainGroup
	
	class func canMakePayments() -> Bool {
		true // bypass iap restrictions
	}
}

class RefreshHook: ClassHook<SKReceiptRefreshRequest> {
	typealias Group = ReceiptGroup
	
	func _wantsRevoked() -> Bool {
		false // no revocations
	}
	
	func _wantsExpired() -> Bool {
		false // no expirations
	}
}

class ObserverHook: ClassHook<SKPaymentQueue> {
	typealias Group = ObserverGroup
	
	func addTransactionObserver(_ arg0: SKPaymentTransactionObserver) {
		let tellaObserver = SatellaObserver.shared // get a shared instance of our observer
		tellaObserver.observer = arg0 // set the shared instance's observer ivar to the app's observer
		orig.addTransactionObserver(tellaObserver) // replace the app's observer with our hacked one
	}
}

class Satella: Tweak {
	required init() { // determine what features to use
		if Preferences.shared.shouldInit() {
			MainGroup().activate()
			if Preferences.shared.receipts.boolValue == true {
				ReceiptGroup().activate()
			}
			
			if Preferences.shared.observer.boolValue == true {
				ObserverGroup().activate()
			}
		}
	}
}