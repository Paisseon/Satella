import Preferences

struct ImageCell: JinxCell {
    let name: String
    let key: String
    let defaultValue: String
    let allowingPhotos: Bool
    let allowingVideos: Bool
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let imageCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: #selector(PSListController.setPreferenceValue(_:specifier:)),
            get: #selector(PSListController.readPreferenceValue(_:)),
            detail: objc_lookUpClass("GcImagePickerCell"),
            cell: .linkCell,
            edit: nil
        )
        
        imageCell.identifier = key
        imageCell.setProperty(key, forKey: "key")
        imageCell.setProperty(defaultValue, forKey: "default")
        imageCell.setProperty("emt.paisseon.satella", forKey: "defaults")
        imageCell.setProperty("emt.paisseon.satella.prefschanged", forKey: "PostNotification")
        imageCell.setProperty(allowingPhotos, forKey: "usesPhotos")
        imageCell.setProperty(allowingVideos, forKey: "usesVideos")
        imageCell.setProperty(0, forKey: "videoQuality")
        
        return imageCell
    }
}
