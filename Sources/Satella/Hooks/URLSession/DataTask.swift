import Foundation.NSURLSession

struct DataTask: Hook {
    typealias URLHandler = @Sendable (
        Data?,
        URLResponse?,
        Error?
    ) -> Void

    typealias T = @convention(c) (
        URLSession,
        Selector,
        URLRequest,
        @escaping (URLHandler)
    ) -> URLSessionDataTask

    let `class`: AnyClass? = URLSession.self
    let selector: Selector = sel_registerName("dataTaskWithRequest:completionHandler:")
    let replacement: T = { target, cmd, request, handler in
        let orig: T = PowPow.unwrap(DataTask.self)!

        if request.url?.absoluteString.contains(".apple.com/verifyReceipt") == true {
            let newHandler: URLHandler = { (_, response, error) in
                let data: Data? = ReceiptGenerator.response()
                handler(data, response, error)
            }

            return orig(target, cmd, request, newHandler)
        }

        return orig(target, cmd, request, handler)
    }
}
