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

class ReceiptHook: ClassHook<SKPaymentTransaction> {
	typealias Group = Receipt
	
	func transactionReceipt() -> Data? {
		let now       = Int64(Date().timeIntervalSince1970) * 1000
		let bvrs      = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		let receiptId = Int.random(in: 1..<999999)
		let vendorId  = UIDevice.current.identifierForVendor?.uuidString
		let bundleId  = Bundle.main.bundleIdentifier
		let uniqueId  = Int.random(in: 1..<999999)
		
		let purchaseInfo = "{\n\t\"original-purchase-date-pst\" = \"\(Date()) America/Los_Angeles\";\n\t\"purchase-date-ms\" = \"\(now)\";\n\t\"unique-identifier\" = \"satella-uid-\(uniqueId)\";\n\t\"original-transaction-id\" = \"satella-tId-\(receiptId)\";\n\t\"bvrs\" = \"\(String(describing: bvrs))\";\n\t\"app-item-id\" = \"\(receiptId)\";\n\t\"transaction-id\" = \"\(receiptId)\";\n\t\"quantity\" = \"1\";\n\t\"original-purchase-date-ms\" = \"\(now)\";\n\t\"unique-vendor-identifier\" = \"\(String(describing: vendorId))\";\n\t\"item-id\" = \"\(receiptId)\";\n\t\"version-external-identifier\" = \"07151129\";\n\t\"product-id\" = \"\(String(describing: target.payment.productIdentifier))\";\n\t\"purchase-date\" = \"\(Date()) Etc/GMT\";\n\t\"original-purchase-date\" = \"\(Date()) Etc/GMT\";\n\t\"bid\" = \"\(String(describing: bundleId))\";\n\t\"purchase-date-pst\" = \"\(Date()) America/Los_Angeles\";\n}"
		
		let purchaseData         = purchaseInfo.data(using: .utf8)
		var purchaseB64: String? = nil
		
		if let purchaseData = purchaseData {
			purchaseB64 = String(data: purchaseData, encoding: .utf8)
		}
		
		let fullReceipt = "{\n\t\"signature\" = \"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\";\n\t\"purchase-info\" = \"\(String(describing: purchaseB64))\";\n\t\"pod\" = \"44\";\n\t\"signing-status\" = \"0\";\n}"
		
		guard let finalReceipt = fullReceipt.data(using: .utf8) else {
			return nil
		}
		
		return finalReceipt
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

class Satella: Tweak {
	required init() {
		if Preferences.shared.shouldInit() {
			Main().activate()
			
			if Preferences.shared.receipts.boolValue == true {
				Receipt().activate()
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