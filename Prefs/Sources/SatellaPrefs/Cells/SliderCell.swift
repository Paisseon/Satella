import Preferences

struct SliderCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: Double
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let sliderCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: nil,
            cell: .sliderCell,
            edit: nil
        )
        
        sliderCell.identifier = key
        sliderCell.setProperty(key, forKey: "key")
        sliderCell.setProperty(defaultValue, forKey: "default")
        sliderCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        sliderCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        
        return sliderCell
    }
}
