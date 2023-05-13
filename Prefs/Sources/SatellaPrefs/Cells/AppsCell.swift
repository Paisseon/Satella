import Preferences

struct AppsCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: Bool
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let appsCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: objc_lookUpClass("ATLApplicationListMultiSelectionController"),
            cell: .linkListCell,
            edit: nil
        )
        
        appsCell.identifier = key
        appsCell.setProperty(key, forKey: "key")
        appsCell.setProperty(defaultValue, forKey: "defaultApplicationSwitchValue")
        appsCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        appsCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        appsCell.setProperty(true, forKey: "showIdentifiersAsSubtitle")
        appsCell.setProperty(true, forKey: "includeIdentifiersInSearch")
        appsCell.setProperty(true, forKey: "useSearchBar")
        appsCell.setProperty(NSArray(array: [["sectionType": "User"]]), forKey: "sections")
        
        return appsCell
    }
}
