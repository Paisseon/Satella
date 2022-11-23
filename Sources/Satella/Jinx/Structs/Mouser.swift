import Foundation

@dynamicMemberLookup
struct Mouser<T> {
    let object: AnyObject
    
    init(
        _ object: AnyObject
    ) {
        self.object = object
    }
    
    private func opaqueIvar<U>(
        _ name: String,
        _ body: ( _ pointer: UnsafeMutablePointer<T>?) throws -> U
    ) rethrows -> U {
        guard let `class`: AnyClass = object_getClass(object),
              let ivar: Ivar = class_getInstanceVariable(`class`, name)
        else {
            return try body(nil)
        }
        
        let offset: Int = ivar_getOffset(ivar)
        
        return try withExtendedLifetime(object) {
            try body(
                (Unmanaged.passUnretained($0).toOpaque() + offset)
                    .assumingMemoryBound(to: T.self)
            )
        }
    }
    
    subscript(
        dynamicMember name: String
    ) -> T? {
        get { opaqueIvar(name) { $0?.pointee } }
        
        nonmutating set {
            guard let val = newValue else {
                return
            }
            
            opaqueIvar(name) { $0?.pointee = val }
        }
    }
}
