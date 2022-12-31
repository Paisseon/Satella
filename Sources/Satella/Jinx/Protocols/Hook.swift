import Foundation

protocol Hook {
    associatedtype T
    
    var `class`: AnyClass? { get }
    var selector: Selector { get }
    var replacement: T { get }
}

extension Hook {
    @discardableResult
    func hook(
        onlyIf condition: Bool = true
    ) -> Bool {
        guard condition, let `class` else {
            return false
        }
        
        return PowPow.hook(
            `class`,
            selector,
            replacement,
            type(of: self)
        )
    }
}
