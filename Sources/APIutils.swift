import Foundation

class APIutils {

    func fetchAPIData(using url: String) -> Data? {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["curl", "-s", url]
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return data
        } catch {
            print("Error while running curl: \(error.localizedDescription)")
            return nil
        }
    }

    func findLatestBuild(from data: Data) -> Int? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let builds = json["builds"] as? [Int] {
                return builds.max()
            }
        } catch {
            print("Error while parsing JSON response: \(error.localizedDescription)")
        }
        return nil
    }

    func findLatestVersion(from data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let versions = json["versions"] as? [String] {

                let latestVersion = versions.sorted { version1, version2 in
                    compareVersions(version1, version2)
                }.last

                return latestVersion
            }
        } catch {
            print("Error while parsing JSON response: \(error.localizedDescription)")
        }
        return nil
    }

    private func compareVersions(_ version1: String, _ version2: String) -> Bool {
        let v1Components = version1.split(separator: ".").map { String($0) }
        let v2Components = version2.split(separator: ".").map { String($0) }

        for (comp1, comp2) in zip(v1Components, v2Components) {
            if comp1 == comp2 { continue }

            if comp1.contains("SNAPSHOT") || comp2.contains("SNAPSHOT") {
                return comp1 < comp2
            }

            if let num1 = Int(comp1), let num2 = Int(comp2) {
                return num1 < num2
            } else {
                return comp1 < comp2
            }
        }

        return v1Components.count < v2Components.count
    }

    func getUUID(playerName: String) -> String? {
        let apiURL = "https://api.mojang.com/users/profiles/minecraft/\(playerName)"
        guard let data = fetchAPIData(using: apiURL) else {
            print("Error while calling Mojang API.")
            return nil
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let rawID = json["id"] as? String {
                let regexPattern = #"""
                ^([a-fA-F0-9]{8})([a-fA-F0-9]{4})([a-fA-F0-9]{4})
                ([a-fA-F0-9]{4})([a-fA-F0-9]{12})$
                """#
                if let regex = try? NSRegularExpression(pattern: regexPattern),
                   let match = regex.firstMatch(
                       in: rawID,
                       range: NSRange(rawID.startIndex..<rawID.endIndex, in: rawID)
                   ) {
                    let formattedID = [
                        rawID[Range(match.range(at: 1), in: rawID)!],
                        rawID[Range(match.range(at: 2), in: rawID)!],
                        rawID[Range(match.range(at: 3), in: rawID)!],
                        rawID[Range(match.range(at: 4), in: rawID)!],
                        rawID[Range(match.range(at: 5), in: rawID)!]
                    ].joined(separator: "-")
                    return formattedID
                }
            }
        } catch {
            print("Error while parsing JSON response: \(error.localizedDescription)")
        }

        print("Could not find valid data.")
        return nil
    }
}
