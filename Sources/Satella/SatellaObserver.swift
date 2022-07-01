import SatellaC
import StoreKit

class SatellaObserver: NSObject, SKPaymentTransactionObserver {
	static let shared = SatellaObserver()
	
	public var observer: SKPaymentTransactionObserver? = nil
	private var purchases                              = [SKPaymentTransaction]()
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
            
            // Prevent duplicate purchases
            
			for purchase in purchases {
				if purchase === transaction {
					return
				}
			}
			
            // Ensure that all purchases are successful, then mark them as finished
            
			switch transaction.transactionState {
				case .purchased:
					purchases.append(transaction)
					queue.finishTransaction(transaction)
				case .restored:
					if let origTrans = transaction.original {
						purchases.append(origTrans)
						queue.finishTransaction(transaction)
					} else {
						transaction._setTransactionState(.purchased)
						transaction._setError(nil)
						purchases.append(transaction)
						queue.finishTransaction(transaction)
					}
				default:
					transaction._setTransactionState(.purchased)
					transaction._setError(nil)
					purchases.append(transaction)
					queue.finishTransaction(transaction)
			}
		}
		
        // Send the hacked list of purchases to the original payment queue for the app to process
        
		observer?.paymentQueue(queue, updatedTransactions: purchases)
	}
	
	private override init() {
		super.init()
	}
}