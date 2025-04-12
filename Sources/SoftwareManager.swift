import Foundation

class SoftwareManager {
    let instanceManager = InstanceManager()

    func completeDownload(type: String, version: String, instanceName: String, memory: Int?, nogui: Bool) {
        switch type.lowercased() {
        case "paper":
            var innerVersion = version

            if version.lowercased() == "latest" {
                let latestVersionURL = "https://api.papermc.io/v2/projects/paper"
                if let data = APIutils().fetchAPIData(using: latestVersionURL) {
                    if let latestVersion = APIutils().findLatestVersion(from: data) {
                        innerVersion = latestVersion
                    }
                }
            }

            let apiURL = "https://api.papermc.io/v2/projects/paper/versions/\(innerVersion)"

            if let data = APIutils().fetchAPIData(using: apiURL) {
                if let latestBuild = APIutils().findLatestBuild(from: data) {
                    _ = downloadServerSoftware(
                        type: type.lowercased(),
                        version: innerVersion,
                        instanceName: instanceName,
                        build: latestBuild
                    )
                    instanceManager.createStartScript(
                        instanceName: instanceName,
                        instanceType: type,
                        instanceVersion: innerVersion,
                        instanceBuild: latestBuild,
                        memory: memory ?? 1024,
                        nogui: nogui
                    )
                } else {
                    print("Invalid version. There might be no build available for this version.")
                }
            } else {
                print("Error while calling PaperMC API.")
            }
        case "velocity":
            var innerVersion = version

            if version.lowercased() == "latest" {
                let latestVersionURL = "https://api.papermc.io/v2/projects/velocity"
                if let data = APIutils().fetchAPIData(using: latestVersionURL) {
                    if let latestVersion = APIutils().findLatestVersion(from: data) {
                        innerVersion = latestVersion
                    }
                }
            }

            let apiURL = "https://api.papermc.io/v2/projects/velocity/versions/\(innerVersion)"
            if let data = APIutils().fetchAPIData(using: apiURL) {
                if let latestBuild = APIutils().findLatestBuild(from: data) {
                    _ = downloadServerSoftware(
                        type: type.lowercased(),
                        version: innerVersion,
                        instanceName: instanceName,
                        build: latestBuild
                    )
                    instanceManager.createStartScript(
                        instanceName: instanceName,
                        instanceType: type,
                        instanceVersion: innerVersion,
                        instanceBuild: latestBuild,
                        memory: memory ?? 1024,
                        nogui: nogui
                    )
                }
            }
        default:
            print("Unsupported type")
        }
    }

    func downloadServerSoftware(
        type: String,
        version: String,
        instanceName: String,
        build: Int
    ) -> (
        output: String?,
        error: String?,
        exitCode: Int32
    ) {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        let base = "https://api.papermc.io/v2/projects/\(type)/versions/\(version)/builds/\(build)"
        let url = "\(base)/downloads/\(type)-\(version)-\(build).jar"
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

        if FileManager.default.fileExists(atPath: "./\(type)-\(version)-\(build).jar") {
            do {
                try FileManager.default.moveItem(
                    atPath: "./\(type)-\(version)-\(build).jar",
                    toPath: "./\(instanceName)/\(type)-\(version)-\(build).jar"
                )
            } catch {
                print("An error occurred while moving server software to destination.")
            }
        }

        return (output?.trimmingCharacters(in: .whitespacesAndNewlines),
                error?.trimmingCharacters(in: .whitespacesAndNewlines),
                process.terminationStatus)
    }
}
