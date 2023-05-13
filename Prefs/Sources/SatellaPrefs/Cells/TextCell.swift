import Preferences

struct TextCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: String
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let textCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: nil,
            cell: .editTextCell,
            edit: nil
        )
        
        textCell.identifier = key
        textCell.setProperty(key, forKey: "key")
        textCell.setProperty(defaultValue, forKey: "default")
        textCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        textCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        
        return textCell
    }
}
