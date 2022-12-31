import Foundation

// resolvingSymlinksInPath() doesn't actually work, so I had to make this

extension URL {
    func realURL() -> URL {
        do {
            let realPath: String = try FileManager.default.destinationOfSymbolicLink(atPath: self.path)
            return URL(fileURLWithPath: realPath)
        } catch {
            return self
        }
    }
}
