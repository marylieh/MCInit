import Foundation

class PluginManager {
    func deployPlugin(url: String, instanceName: String) -> (output: String?, error: String?, exitCode: Int32) {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", "curl -O \(url)"]
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return (nil, "Failed to run process: \(error.localizedDescription)", -1)
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)
        let error = String(data: errorData, encoding: .utf8)

        if !FileManager.default.fileExists(atPath: "./\(instanceName)/plugins") {
            do {
                try FileManager.default.createDirectory(
                    atPath: "./\(instanceName)/plugins",
                    withIntermediateDirectories: true
                )
            } catch {
                print("An error occurred while creating plugins directory.")
            }
        }

        if FileManager.default.fileExists(atPath: ".\(url.split(separator: "/").last!)") {
            do {
                try FileManager.default.moveItem(
                    atPath: ".\(url.split(separator: "/").last!)",
                    toPath: "./\(instanceName)/plugins/\(url.split(separator: "/").last!)"
                )
            } catch {
                print("An error occurred while moving plugin to destination.")
            }
        }

        return (output?.trimmingCharacters(in: .whitespacesAndNewlines),
                error?.trimmingCharacters(in: .whitespacesAndNewlines),
                process.terminationStatus)
    }
}
