import Preferences

struct GroupCell: JinxCell {
    let name: String
    let footerText: String
    
    func specifier(for target: PSListController) -> PSSpecifier {
        let groupCell: PSSpecifier = .emptyGroup()
        
        groupCell.name = name
        groupCell.identifier = name
        
        if !footerText.isEmpty {
            groupCell.setProperty(footerText, forKey: "footerText")
        }
        
        return groupCell
    }
}
