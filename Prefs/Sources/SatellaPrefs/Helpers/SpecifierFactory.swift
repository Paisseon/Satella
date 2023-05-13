import Preferences

struct SpecifierFactory {
    static func add(
        _ cells: [JinxCell],
        to specifiers: inout NSMutableArray,
        in target: PSListController
    ) {
        _ = cells.map {
            specifiers.add($0.specifier(for: target))
        }
    }
}
