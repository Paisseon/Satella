import SatellaC
import StoreKit

class SatellaObserver: NSObject, SKPaymentTransactionObserver {
	public var observer: SKPaymentTransactionObserver? = nil // the real observer– we use it because it has the code to handle purchases
	private var purchases = [SKPaymentTransaction]() // our list of purchases to send to the real observer
	static let shared = SatellaObserver() // use a singleton
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions { // loop through new transactions
			for purchase in purchases { // loop through existing purchases
				if purchase === transaction { return } // if a transaction takes the same memory as a previous transaction, block it. thanks to u/oopsuwu for finding this bug in satella 1 ^^
			}
			
			switch transaction.transactionState { // check each possible state 
				case .purchased:
					purchases.append(transaction) // if the transaction is already marked as purchased, add it to the list of purchases
					queue.finishTransaction(transaction) // tell the queue to finish processing this transaction
				case .restored:
					if let origTrans = transaction.original { // get the original transaction
						purchases.append(origTrans) // add it to the list of purchases
						queue.finishTransaction(transaction) // finish it
					} else { // if we can't find the original transaction for whatever reason, just use the default response
						transaction._setTransactionState(.purchased) // set the code as purchased
						transaction._setError(nil) // set the error as nil
						purchases.append(transaction) // add to the list
						queue.finishTransaction(transaction) // finish it
					}
				default: // handles all other states with the same code as the else-block in .restored
					transaction._setTransactionState(.purchased)
					transaction._setError(nil)
					purchases.append(transaction)
					queue.finishTransaction(transaction) // finish it
			}
		}
		
		observer?.paymentQueue(queue, updatedTransactions: purchases) // send our hacked list of purchases to the original observer
	}
	
	private override init() {
		super.init() // this is just overridden to make a proper singleton
	}
}