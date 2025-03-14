import Foundation

struct ServerPropertiesManager {
    private var properties: [String: String] = [:]

    init(filePath: String) throws {
        if FileManager.default.fileExists(atPath: filePath) {
            let contents = try String(contentsOfFile: filePath)
            properties = Dictionary(
                uniqueKeysWithValues: contents
                    .split(separator: "\n")
                    .map { line in
                        let parts = line.split(separator: "=", maxSplits: 1).map { String($0) }
                        return (parts[0], parts.count > 1 ? parts[1] : "")
                    }
                )
        }
    }

    mutating func set(_ property: ServerProperty, to value: String?) {
        properties[property.rawValue] = value ?? property.defaultValue
    }

    func save(to filePath: String) throws {
        let contents = properties.map { "\($0.key)=\($0.value)" }.joined(separator: "\n")
        try contents.write(toFile: filePath, atomically: true, encoding: .utf8)
    }

    func get(_ property: ServerProperty) -> String {
        return properties[property.rawValue] ?? property.defaultValue
    }
}
