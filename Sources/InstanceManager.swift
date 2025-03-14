import Foundation
import ArgumentParser

class InstanceManager {

    func initializeInstance(name: String) throws -> String {
        let directoryPath = "./\(name)"

        if !FileManager.default.fileExists(atPath: directoryPath) {
            try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
            try createPluginDirectory(instanceName: name)
            return "Initialized new server as \(name)"
        } else {
            throw ValidationError("Instance directory already exists.")
        }
    }

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
                    createStartScript(
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
                    createStartScript(
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
        process.arguments = ["-c", "curl -O https://api.papermc.io/v2/projects/\(type)/versions/\(version)/builds/\(build)/downloads/\(type)-\(version)-\(build).jar"]
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
                try FileManager.default.moveItem(atPath: "./\(type)-\(version)-\(build).jar", toPath: "./\(instanceName)/\(type)-\(version)-\(build).jar")
            } catch {
                print("An error occurred while moving server software to destination.")
            }
        }

        return (output?.trimmingCharacters(in: .whitespacesAndNewlines),
                error?.trimmingCharacters(in: .whitespacesAndNewlines),
                process.terminationStatus)
    }

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
                try FileManager.default.createDirectory(atPath: "./\(instanceName)/plugins", withIntermediateDirectories: true)
            } catch {
                print("An error occurred while creating plugins directory.")
            }
        }

        if FileManager.default.fileExists(atPath: ".\(url.split(separator: "/").last!)") {
            do {
                try FileManager.default.moveItem(atPath: ".\(url.split(separator: "/").last!)", toPath: "./\(instanceName)/plugins/\(url.split(separator: "/").last!)")
            } catch {
                print("An error occurred while moving plugin to destination.")
            }
        }

        return (output?.trimmingCharacters(in: .whitespacesAndNewlines),
                error?.trimmingCharacters(in: .whitespacesAndNewlines),
                process.terminationStatus)
    }

    func acceptEula(instanceName: String) throws {
        let fileName = "eula.txt"
        let path = URL(string: "./\(instanceName)/\(fileName)")!
        let writableText = "eula=true"

        do {
            try writableText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("An error occured while writing eula.txt: \(error.localizedDescription)")
        }
    }

    func createStartScript(instanceName: String, instanceType: String, instanceVersion: String, instanceBuild: Int, memory: Int, nogui: Bool = false) {
        let fileName = "start.sh"
        let path = URL(string: "./\(instanceName)/\(fileName)")!
        var writableText = "java -Xms512M -Xmx\(memory)M -jar \(instanceType)-\(instanceVersion)-\(instanceBuild).jar"

        if nogui {
            writableText.append(" --nogui -o true")
        }

        do {
            try writableText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("An error occured while writing start.sh: \(error.localizedDescription)")
        }
    }

    func addOperator(instanceName: String, playerName: String) {
        if let playerUUID = APIutils().getUUID(playerName: playerName) {
            let fileName = "ops.json"
            let path = URL(string: "./\(instanceName)/\(fileName)")!
            let writableText = """
            [
              {
                "uuid": "\(playerUUID)",
                "name": "\(playerName)",
                "level": 4,
                "bypassesPlayerLimit": false
              }
            ]
            """

            do {
                try writableText.write(to: path, atomically: true, encoding: .utf8)
            } catch {
                print("An error occured while writing ops.json: \(error.localizedDescription)")
            }
        }
    }

    func addWhitelist(instanceName: String, playerName: String) {
        let players = playerName.split(separator: ",").map { String($0) }
        let fileName = "whitelist.json"
        let path = URL(string: "./\(instanceName)/\(fileName)")!
        var writableText = """
                [
                """
        if players.count > 1 {
            players.forEach { player in
                if let uuid = APIutils().getUUID(playerName: player) {

                    if players.last == player {
                        writableText.append("""
                        
                          {
                            "uuid": "\(uuid)",
                            "name": "\(player)"
                          }
                        """)
                    } else {
                        writableText.append("""
                        
                          {
                            "uuid": "\(uuid)",
                            "name": "\(player)"
                          },
                        """)
                    }
                }
            }
            writableText.append("\n]")
        } else {
            if let uuid = APIutils().getUUID(playerName: playerName) {
                writableText.append("""
                    
                      {
                        "uuid": "\(uuid)",
                        "name": "\(playerName)"
                      }
                    ]
                    """)
            }
        }

        do {
            try writableText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("An error occured while writing whitelist.json: \(error.localizedDescription)")
        }
    }

    func setServerProperty(property: ServerProperty, value: String, instanceName: String) throws {
        var serverPropertyManager = try ServerPropertiesManager(filePath: "./\(instanceName)/server.properties")

        serverPropertyManager.set(property, to: value)

        do {
            try serverPropertyManager.save(to: "./\(instanceName)/server.properties")
        } catch {
            print("An error occured while saving server.properties: \(error.localizedDescription)")
        }
    }

    private func createPluginDirectory(instanceName: String) throws {
        do {
            try FileManager.default.createDirectory(atPath: "./\(instanceName)/plugins", withIntermediateDirectories: true)
        } catch {
            print("An error occurred while trying to create plugin directory: \(error.localizedDescription)")
        }
    }
}
