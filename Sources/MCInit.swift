import ArgumentParser
import Foundation

@main
struct MCInit: ParsableCommand {
    @Argument(help: "The Name of the new instance.")
    var name: String

    @Option(name: .shortAndLong, help: "Server type (Paper, Velocity)")
    var type: String

    @Option(name: .shortAndLong, help: "Server version (e.G. 1.21.1). Default is latest.")
    var version: String = "latest"

    @Flag(name: .shortAndLong, help: "Accept Mojang EULA")
    var eula = false

    @Option(name: .shortAndLong, help: "Memory in Megabyte. Default is 1024 which is 1GB")
    var memory = 1024

    @Flag(name: .shortAndLong, help: "No GUI mode disables the Server GUI.")
    var nogui = false

    @Option(name: .shortAndLong, help: "Server operator (Only one player can be initial operator)")
    var operatorName: String?

    @Option(name: .shortAndLong, help: "Allow players to join your server (comma separated)")
    var allowlist: String?

    @Option(name: .shortAndLong, help: "Server default gamemode. (creative, adventure, survival, spectator)")
    var gamemode: String?

    @Option(name: .shortAndLong, help: "Server difficulty (peaceful, easy, normal, hard)")
    var difficulty: String?

    @Option(name: .long, help: "Server Message of the Day (MotD)")
    var motd: String?

    func run() throws {
        let instanceManager = InstanceManager()
        let softwareManager = SoftwareManager()

        if eula == false {
            print("You must accept the Mojang EULA to continue.")
            return
        }

        _ = try instanceManager.initializeInstance(name: name)
        softwareManager.completeDownload(type: type, version: version, instanceName: name, memory: memory, nogui: nogui)
        try instanceManager.acceptEula(instanceName: name)

        if let operatorName = operatorName {
            instanceManager.addOperator(instanceName: name, playerName: operatorName)
        }

        if let allowlist = allowlist {
            instanceManager.addAllowlist(instanceName: name, playerName: allowlist)
            try instanceManager.setServerProperty(property: ServerProperty.whiteList, value: "true", instanceName: name)
        }

        if let gamemode = gamemode {
            let validGamemodes: Set<String> = ["creative", "adventure", "survival", "spectator"]

            if !validGamemodes.contains(gamemode.lowercased()) {
                print("Invalid gamemode. Please choose from: \(validGamemodes.joined(separator: ", "))")
                return
            }

            try instanceManager.setServerProperty(
                property: ServerProperty.gamemode,
                value: gamemode.lowercased(),
                instanceName: name
            )
        }

        if let difficulty = difficulty {
            let validDifficulties: Set<String> = ["peaceful", "easy", "normal", "hard"]

            if !validDifficulties.contains(difficulty.lowercased()) {
                print("Invalid difficulty. Please choose from: \(validDifficulties.joined(separator: ", "))")
                return
            }

            try instanceManager.setServerProperty(
                property: ServerProperty.difficulty,
                value: difficulty.lowercased(),
                instanceName: name
            )
        }

        if let motd = motd {
            try instanceManager.setServerProperty(property: ServerProperty.motd, value: motd, instanceName: name)
        }

        print("Successfully initialized new instance \(name) with \(type) \(version) and \(memory)M of memory.")
    }
}
