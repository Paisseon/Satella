import Foundation
import MachO

// MARK: - PowPow

struct PowPow {
    // MARK: Internal

    typealias AnyType = Any.Type

    static let native: Hooker = {
        switch Tweak.config {
            case .dynamic:
                break
            case .jinx:
                return .jinx
            case .libhooker:
                return .libhooker
            case .substitute:
                return .substitute
            case .substrate:
                return .substrate
            case .xina:
                return .xina
        }
        
        if access(URL(fileURLWithPath: "/var/jb/usr/lib/libsubstitute.dylib").realURL().path, F_OK) == 0 {
            return .xina
        }
        
        let hookingLibraries: [(String, Hooker)] = [
            ("libhooker", .libhooker),
            ("libsubstitute", .substitute),
            ("libsubstrate", .substrate)
        ]
        
        for i in 0 ..< 3 {
            if access("/usr/lib/\(hookingLibraries[i].0).dylib", F_OK) == 0 {
                return hookingLibraries[i].1
            }
        }
        
        return .jinx
    }()
    
    static let isArm64e: Bool = {
        guard let archRaw = NXGetLocalArchInfo().pointee.name else {
            return false
        }
        
        return strcasecmp(archRaw, "arm64e") == 0
    }()

    @discardableResult
    static func hook(
        _ class: AnyClass,
        _ selector: Selector,
        _ replacement: some Any,
        _ key: AnyType
    ) -> Bool {
        switch native {
            case .jinx:
                return hookInternal(
                    `class`,
                    selector,
                    replacement,
                    key
                )
                
            case .libhooker:
                return hookLibhooker(
                    `class`,
                    selector,
                    replacement,
                    key
                )
                
            case .substitute:
                return hookSubstitute(
                    `class`,
                    selector,
                    replacement,
                    key,
                    false
                )
                
            case .substrate:
                return hookSubstrate(
                    `class`,
                    selector,
                    replacement,
                    key
                )
                
            case .xina:
                return hookSubstitute(
                    `class`,
                    selector,
                    replacement,
                    key,
                    true
                )
        }
    }
    
    @discardableResult
    static func hookFunc(
        _ function: String,
        _ image: String?,
        _ replacement: UnsafeMutableRawPointer,
        _ key: AnyType
    ) -> Bool {
        if native == .jinx || isArm64e {
            return hookFuncInternal(
                function,
                image,
                replacement,
                key
            )
        }
        
        return hookFuncSubstrate(
            function,
            image,
            replacement,
            key,
            native == .xina
        )
    }
    
    static func unwrap<T>(
        _ key: AnyType
    ) -> T? {
        if let unwrapped: T = unsafeBitCast(voidStack.pop(key), to: T?.self) {
            return unwrapped
        }
        
        if let unwrapped: T = unsafeBitCast(impStack.pop(key), to: T?.self) {
            return unwrapped
        }
        
        return nil
    }

    // MARK: Private

    private static func hookFuncInternal(
        _ function: String,
        _ image: String?,
        _ replacement: UnsafeMutableRawPointer,
        _ key: AnyType
    ) -> Bool {
        var rebind: FishBones = .init()
        var tmp: UnsafeMutableRawPointer?
        
        let ret: Bool = rebind.hook(
            function,
            image,
            replacement,
            &tmp
        )
        
        voidStack.push(key, tmp)
        
        return ret
    }

    private static func hookFuncSubstrate(
        _ function: String,
        _ image: String?,
        _ replacement: UnsafeMutableRawPointer,
        _ key: AnyType,
        _ xina: Bool
    ) -> Bool {
        var tmp: UnsafeMutableRawPointer?
        let dylib: String = xina ?  URL(fileURLWithPath: "/var/jb/usr/lib/libsubstitute.dylib").realURL().path : "/usr/lib/libsubstrate.dylib"
        
        guard
            let MSFindSymbol: MF = getHookingSymbol(
                dylib,
                "MSFindSymbol"
            ),
            let MSGetImageByName: MG = getHookingSymbol(
                dylib,
                "MSGetImageByName"
            ),
            let MSHookFunction: MH = getHookingSymbol(
                dylib,
                "MSHookFunction"
            )
        else {
            return false
        }
        
        guard let symbol: UnsafeMutableRawPointer = MSFindSymbol(
            image != nil ? MSGetImageByName(image!) : nil,
            function
        ) else {
            return false
        }
        
        MSHookFunction(symbol, replacement, &tmp)
        voidStack.push(key, tmp)
        
        return true
    }

    private static func getHookingSymbol<T>(
        _ image: String,
        _ symbol: String
    ) -> T? {
        if let handle: UnsafeMutableRawPointer = hndlStack.pop(image) {
            guard let fnSym: T = unsafeBitCast(dlsym(handle, symbol), to: T?.self) else {
                dlclose(handle)
                return nil
            }
            
            return fnSym
        } else {
            guard let handle: UnsafeMutableRawPointer = dlopen(image, RTLD_GLOBAL | RTLD_LAZY) else {
                return nil
            }
            
            guard let fnSym: T = unsafeBitCast(dlsym(handle, symbol), to: T?.self) else {
                dlclose(handle)
                return nil
            }
            
            return fnSym
        }
    }
    
    private static func hookInternal(
        _ class: AnyClass,
        _ selector: Selector,
        _ replacement: some Any,
        _ key: AnyType
    ) -> Bool {
        guard
            let imp: IMP = unsafeBitCast(
                replacement,
                to: IMP?.self
            ),
            let orig: Method = class_getInstanceMethod(
                `class`,
                selector
            ),
            let types: UnsafePointer<Int8> = method_getTypeEncoding(orig)
        else {
            return false
        }
        
        let tmp: IMP = class_addMethod(`class`, selector, imp, types) ? method_getImplementation(orig) : method_setImplementation(orig, imp)
        impStack.push(key, tmp)
        
        return true
    }
    
    private static func hookLibhooker(
        _ class: AnyClass,
        _ selector: Selector,
        _ replacement: some Any,
        _ key: AnyType
    ) -> Bool {
        guard let LBHookMessage: LH = getHookingSymbol(
            "/usr/lib/libblackjack.dylib",
            "LBHookMessage"
        ) else {
            return false
        }
        
        let replacementPtr: UnsafeMutableRawPointer? = unsafeBitCast(
            replacement,
            to: UnsafeMutableRawPointer?.self
        )
        
        guard replacementPtr != nil else {
            return false
        }
        
        var tmp: UnsafeMutableRawPointer?
        
        let status: Int16 = LBHookMessage(
            `class`,
            selector,
            replacementPtr,
            &tmp
        )
        
        voidStack.push(key, tmp)
        
        return status == 0
    }
    
    private static func hookSubstitute(
        _ class: AnyClass,
        _ selector: Selector,
        _ replacement: some Any,
        _ key: AnyType,
        _ xina: Bool
    ) -> Bool {
        guard let substitute_hook_objc_message: SH = getHookingSymbol(
            xina ? URL(fileURLWithPath: "/var/jb/usr/lib/libsubstitute.dylib").realURL().path : "/usr/lib/libsubstitute.dylib",
            "substitute_hook_objc_message"
        ) else {
            return false
        }
        
        let replacementPtr: UnsafeMutableRawPointer? = unsafeBitCast(
            replacement,
            to: UnsafeMutableRawPointer?.self
        )
        
        guard replacementPtr != nil else {
            return false
        }
        
        var tmp: UnsafeMutableRawPointer?
        
        let status: Int32 = substitute_hook_objc_message(
            `class`,
            selector,
            replacementPtr,
            &tmp,
            nil
        )
        
        voidStack.push(key, tmp)
        
        return status == 0
    }
    
    private static func hookSubstrate(
        _ class: AnyClass,
        _ selector: Selector,
        _ replacement: some Any,
        _ key: AnyType
    ) -> Bool {
        guard let MSHookMessageEx: MX = getHookingSymbol(
            "/usr/lib/libsubstrate.dylib",
            "MSHookMessageEx"
        ) else {
            return false
        }
        
        guard let replacementImp: IMP = unsafeBitCast(
            replacement,
            to: IMP?.self
        ) else {
            return false
        }
        
        var tmp: IMP?
        
        MSHookMessageEx(`class`, selector, replacementImp, &tmp)
        impStack.push(key, tmp)
        
        return true
    }
}

@_cdecl("jinxInit")
func jinxInit() {
    Tweak.ctor()
}
