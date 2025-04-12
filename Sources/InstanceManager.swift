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

    func createStartScript(
        instanceName: String,
        instanceType: String,
        instanceVersion: String,
        instanceBuild: Int,
        memory: Int,
        nogui: Bool = false
    ) {
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

    func addAllowlist(instanceName: String, playerName: String) {
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
            try FileManager.default.createDirectory(
                atPath: "./\(instanceName)/plugins",
                withIntermediateDirectories: true
            )
        } catch {
            print("An error occurred while trying to create plugin directory: \(error.localizedDescription)")
        }
    }
}
