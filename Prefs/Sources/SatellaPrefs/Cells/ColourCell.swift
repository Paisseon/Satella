import Preferences

struct ColourCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: String
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let colourCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: objc_lookUpClass("HBColorPickerTableCell"),
            cell: .linkCell,
            edit: nil
        )
        
        colourCell.identifier = key
        colourCell.setProperty(key, forKey: "key")
        colourCell.setProperty(defaultValue, forKey: "default")
        colourCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        colourCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        colourCell.setProperty(true, forKey: "showAlphaSlider")
        
        return colourCell
    }
}
