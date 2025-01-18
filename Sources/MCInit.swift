import ArgumentParser
import Foundation

@main
struct MCInit: ParsableCommand {
    @Argument(help: "The Name of the new instance.")
    var name: String
    
    @Option(name: .shortAndLong, help: "Server type (Paper, Velocity)")
    var type: String
    
    @Option(name: .shortAndLong, help: "Server version (e.G. 1.21.1)")
    var version: String
    
    @Flag(name: .shortAndLong, help: "Accept Mojang EULA")
    var eula = false
    
    @Option(name: .shortAndLong, help: "Memory in Mibibyte. Default is 1024 which is 1GB")
    var memory = 1024
    
    func run() throws {
        let instanceManager = InstanceManager()
        
        if eula == false {
            print("You must accept the Mojang EULA to continue.")
            return
        }
        
        let _ = try instanceManager.initializeInstance(name: name)
        instanceManager.completeDownload(type: type, version: version, instanceName: name, memory: memory)
        try instanceManager.acceptEula(instanceName: name)
        
        print("Successfully initialized new instance \(name) with \(type) \(version) and \(memory)M of memory.")
    }
}
