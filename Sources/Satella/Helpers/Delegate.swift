import StoreKit

final class SatellaDelegate: NSObject, SKProductsRequestDelegate {
    static let shared: SatellaDelegate = .init()
    var delegates: [SKProductsRequestDelegate] = []
    var products: [SKProduct] = []
    
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        // If the app is not sideloaded, pass orig values
        
        guard response.products.isEmpty else {
            for delegate in delegates {
                delegate.productsRequest(request, didReceive: response)
            }
            
            return
        }
        
        // We only need to set the products list once
        
        if products.isEmpty {
            let _request: AnyObject? = request.value(forKey: "_productsRequestInternal") as? AnyObject
            let _identifiers: Set<String>? = _request?.value(forKey: "_productIdentifiers") as? Set<String>
            let identifiers: [String] = .init(_identifiers ?? [])
            
            for identifier in identifiers {
                let product: SKProduct = .init()
                let price: NSDecimalNumber = 0.01
                
                product.setValuesForKeys([
                    "price": price,
                    "priceLocale": Locale(identifier: "da_DK"),
                    "productIdentifier": identifier,
                    "localizedDescription": identifier,
                    "localizedTitle": identifier
                ])
                
                products.append(product)
            }
        }
        
        // Send a fake response so the app recognises products without App Store connection
        
        let fakeResponse: SKProductsResponse = .init()
        fakeResponse.setValue(products, forKey: "products")
        
        for delegate in delegates {
            delegate.productsRequest(request, didReceive: fakeResponse)
        }
    }
}
