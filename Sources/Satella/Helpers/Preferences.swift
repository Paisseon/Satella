import Foundation

// MARK: - Preferences

final class Preferences {
    // MARK: Lifecycle

    private init() {
        let truePrefs: _Preferences = .init()

        apps = truePrefs.get(for: "apps", default: [String]())
        isEnabled = truePrefs.get(for: "isEnabled", default: true)
        isGloballyInjected = truePrefs.get(for: "isGloballyInjected", default: false)
        isObserver = truePrefs.get(for: "isObserver", default: false)
        isPriceZero = truePrefs.get(for: "isPriceZero", default: false)
        isReceipt = truePrefs.get(for: "isReceipt", default: false)
        isSideloaded = truePrefs.get(for: "isSideloaded", default: false)
    }

    // MARK: Internal

    static let shared: Preferences = .init()

    let apps: [String]
    let isEnabled: Bool
    let isGloballyInjected: Bool
    let isObserver: Bool
    let isPriceZero: Bool
    let isReceipt: Bool
    let isSideloaded: Bool

    func shouldInject() -> Bool {
        guard isEnabled else {
            return false
        }

        if !isGloballyInjected {
            return apps.contains(Bundle.main.bundleIdentifier ?? "")
        }

        return true
    }
}

// MARK: - _Preferences

private struct _Preferences {
    // MARK: Lifecycle

    init() {
        let domain: CFString = "emt.paisseon.satella" as CFString

        if NSHomeDirectory() == "/var/mobile" {
            let keyList: CFArray = CFPreferencesCopyKeyList(
                domain,
                kCFPreferencesCurrentUser,
                kCFPreferencesAnyHost
            ) ?? [] as CFArray

            dict = CFPreferencesCopyMultiple(
                keyList,
                domain,
                kCFPreferencesCurrentUser,
                kCFPreferencesAnyHost
            ) as? [String: Any] ?? [:]
        } else {
            let prefsURL: URL = .init(fileURLWithPath: "/var/mobile/Library/Preferences/\(domain).plist")
            
            guard access(prefsURL.path, F_OK) == 0,
                  let data: Data = try? .init(contentsOf: prefsURL),
                  let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            else {
                dict = [:]
                return
            }
            
            dict = plist as? [String: Any] ?? [:]
        }
    }

    // MARK: Internal

    func get<T>(
        for key: String,
        default val: T
    ) -> T {
        dict[key] as? T ?? val
    }

    // MARK: Private

    private let dict: [String: Any]
}
