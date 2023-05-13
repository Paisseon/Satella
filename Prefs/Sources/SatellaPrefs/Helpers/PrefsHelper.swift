import UIKit

struct PrefsHelper {
    private static let cfDomain: CFString = "emt.paisseon.satella" as CFString
    
    private static func safeBitCast<T>(
        _ ptr: OpaquePointer?,
        to type: T.Type
    ) -> T {
        let tPtr: UnsafePointer<T> = withUnsafePointer(to: ptr, { UnsafeRawPointer($0).bindMemory(to: T.self, capacity: 1) })
        return tPtr.pointee
    }
    
    private static func privImp<T>(
        forClass cls: AnyClass,
        andSelector sel: Selector
    ) -> T? {
        typealias MethodGetter = @convention(c) (AnyClass?, Selector) -> Method?
        
        let getMethod: MethodGetter = class_isMetaClass(cls) ? class_getClassMethod : class_getInstanceMethod
        guard let method: Method = getMethod(cls, sel) else { return nil }
        let imp: OpaquePointer = method_getImplementation(method)
        
        return safeBitCast(imp, to: T?.self)
    }
    
    private static func read() -> [String: Any] {
        let keyList: CFArray = CFPreferencesCopyKeyList(
            cfDomain,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        ) ?? CFArrayCreate(nil, nil, 0, nil)
        
        let cfDict: CFDictionary = CFPreferencesCopyMultiple(
            keyList,
            cfDomain,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        
        return cfDict as? [String: Any] ?? [:]
    }
    
    static func getValue(
        for key: String,
        fallback: Any? = nil
    ) -> Any? {
        let dict: [String: Any] = read()
        return dict[key] ?? fallback
    }
    
    static func write() {
        #if JINX_ROOTLESS
        let dict: [String: Any] = read()
        let url: URL = .init(fileURLWithPath: "/var/jb/var/mobile/Library/Preferences/\(cfDomain as String).plist")
        let data: Data? = try? PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: 0)
        try? data?.write(to: url)
        #endif
    }
    
    static func respring(withView view: UIView) {
        typealias RelaunchType = @convention(c) (AnyObject, Selector, String, Int, URL) -> NSObject
        let actionSel: Selector = sel_registerName("actionWithReason:options:targetURL:")
        
        guard let relObj: NSObject.Type = objc_getClass("SBSRelaunchAction") as? NSObject.Type,
              let relCls: AnyClass = objc_getMetaClass("SBSRelaunchAction") as? AnyClass,
              let srvObj: NSObject.Type = objc_getClass("FBSSystemService") as? NSObject.Type,
              let service: NSObject = srvObj.perform(sel_registerName("sharedService")).takeUnretainedValue() as? NSObject,
              let relaunch: RelaunchType = PrefsHelper.privImp(forClass: relCls, andSelector: actionSel),
              let retURL: URL = .init(string: "prefs:root=Tweaks&path=Satella")
        else {
            return
        }
        
        let action: NSObject = relaunch(relObj, actionSel, "RestartRenderServer", 1 << 2, retURL)
        let serviceSel: Selector = sel_registerName("sendActions:withResult:")
        
        if #available(iOS 13, *) {
            let effect: UIBlurEffect = .init(style: .systemChromeMaterialDark)
            let blurView: UIVisualEffectView = .init(effect: effect)
            let blurAni: () -> Void = { blurView.alpha = 1.0 }
            
            blurView.frame = UIScreen.main.bounds
            blurView.alpha = 0.0
            
            view.window?.rootViewController?.view.addSubview(blurView)
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: blurAni) { _ in
                service.perform(serviceSel, with: NSSet(object: action), with: nil)
            }
            
            return
        }
        
        service.perform(serviceSel, with: NSSet(object: action), with: nil)
    }
}
