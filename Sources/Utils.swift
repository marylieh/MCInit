import Foundation

class Utils {
    func getFileContent(path: String) -> String {
        if let fileData = FileManager.default.contents(atPath: path) {
            if let fileContent = String(data: fileData, encoding: .utf8) {
                return fileContent
            } else {
                return "Could not convert file data to UTF8"
            }
        } else {
            return "File not found"
        }
    }
}
