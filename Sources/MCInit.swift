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
    
    @Option(name: .shortAndLong, help: "Whitelist players (comma separated)")
    var whitelist: String?
    
    @Option(name: .shortAndLong, help: "Server default gamemode. (creative, adventure, survival, spectator)")
    var gamemode: String?
    
    @Option(name: .shortAndLong, help: "Server difficulty (peaceful, easy, normal, hard)")
    var difficulty: String?
    
    @Option(name: .long, help: "Server Message of the Day (MotD)")
    var motd: String?
    
    func run() throws {
        let instanceManager = InstanceManager()
        
        if eula == false {
            print("You must accept the Mojang EULA to continue.")
            return
        }
        
        let _ = try instanceManager.initializeInstance(name: name)
        instanceManager.completeDownload(type: type, version: version, instanceName: name, memory: memory, nogui: nogui)
        try instanceManager.acceptEula(instanceName: name)
        
        if let operatorName = operatorName {
            instanceManager.addOperator(instanceName: name, playerName: operatorName)
        }
        
        if let whitelist = whitelist {
            instanceManager.addWhitelist(instanceName: name, playerName: whitelist)
            try instanceManager.setServerProperty(property: ServerProperty.whiteList, value: "true", instanceName: name)
        }
        
        if let gamemode = gamemode {
            if gamemode.lowercased() != "creative" && gamemode.lowercased() != "adventure" && gamemode.lowercased() != "survival" && gamemode.lowercased() != "spectator" {
                print("Invalid gamemode. Please choose from: creative, adventure, survival, spectator")
                return
            }
            
            try instanceManager.setServerProperty(property: ServerProperty.gamemode, value: gamemode.lowercased(), instanceName: name)
        }
        
        if let difficulty = difficulty {
            if difficulty.lowercased() != "peaceful" && difficulty.lowercased() != "easy" && difficulty.lowercased() != "normal" && difficulty.lowercased() != "hard" {
                print("Invalid difficulty. Please choose from: peaceful, easy, normal, hard")
                return
            }
            
            try instanceManager.setServerProperty(property: ServerProperty.difficulty, value: difficulty.lowercased(), instanceName: name)
        }
        
        if let motd = motd {
            try instanceManager.setServerProperty(property: ServerProperty.motd, value: motd, instanceName: name)
        }
        
        print("Successfully initialized new instance \(name) with \(type) \(version) and \(memory)M of memory.")
    }
}
