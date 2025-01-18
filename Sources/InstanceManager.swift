import Foundation
import ArgumentParser

class InstanceManager {
    
    func initializeInstance(name: String) throws -> String {
        let directoryPath = "./\(name)"
        
        if !FileManager.default.fileExists(atPath: directoryPath) {
            try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
            return "Initialized new server as \(name)"
        } else {
            throw ValidationError("Instance directory already exists.")
        }
    }
    
    func completeDownload(type: String, version: String, instanceName: String, memory: Int?) {
        switch type.lowercased() {
        case "paper":
            let apiURL = "https://api.papermc.io/v2/projects/paper/versions/\(version)"
            if let data = APIutils().fetchAPIData(using: apiURL) {
                if let latestBuild = APIutils().findLatestBuild(from: data) {
                    let _ = downloadServerSoftware(type: type.lowercased(), version: version, instanceName: instanceName, build: latestBuild)
                    createStartScript(instanceName: instanceName, instanceType: type, instanceVersion: version, instanceBuild: latestBuild, memory: memory ?? 1024)
                } else {
                    print("Invalid version. There might be no build available for this version.")
                }
            } else {
                print("Error while calling PaperMC API.")
            }
        default:
            print("Unsupported type")
        }
    }
    
    func downloadServerSoftware(type: String, version: String, instanceName: String, build: Int) -> (output: String?, error: String?, exitCode: Int32) {
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
    
    func fetchLatestPaperVersion(version: String) -> Int? {
        let url = "https://api.papermc.io/v2/projects/paper/versions/\(version)"
        
        if let data = APIutils().fetchAPIData(using: url) {
            if let latestBuild = APIutils().findLatestBuild(from: data) {
                return latestBuild
            } else {
                return 0
            }
        } else {
            return 0
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
    
    func createStartScript(instanceName: String, instanceType: String, instanceVersion: String, instanceBuild: Int, memory: Int) {
        let fileName = "start.sh"
        let path = URL(string: "./\(instanceName)/\(fileName)")!
        let writableText = "java -Xms512M -Xmx\(memory)M -jar \(instanceType)-\(instanceVersion)-\(instanceBuild).jar --nogui -o true"
        
        do {
            try writableText.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("An error occured while writing start.sh: \(error.localizedDescription)")
        }
    }
}
