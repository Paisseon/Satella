import Preferences

struct ButtonCell: JinxCell {
    let name: String
    let action: Selector
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let buttonCell: PSSpecifier = .preferenceSpecifierNamed(
            name,
            target: target,
            set: nil,
            get: nil,
            detail: nil,
            cell: .buttonCell,
            edit: nil
        )
        
        buttonCell.buttonAction = action
        
        return buttonCell
    }
}
