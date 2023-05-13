import Preferences

struct ToggleCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: Bool
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let toggleCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: nil,
            cell: .switchCell,
            edit: nil
        )
        
        toggleCell.identifier = key
        toggleCell.setProperty(key, forKey: "key")
        toggleCell.setProperty(defaultValue, forKey: "default")
        toggleCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        toggleCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        
        return toggleCell
    }
}
