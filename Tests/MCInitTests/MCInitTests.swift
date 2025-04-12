import XCTest
@testable import MCInit

final class MCInitTests: XCTestCase {
    func testDirectoryCreation() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let expectedOutput = "Initialized new server as \(instanceName)"
        
        // Act
        let result = try instanceManager.initializeInstance(name: instanceName)
        
        // Assert
        XCTAssertEqual(result, expectedOutput)
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testFetchLatestPaperVersion() throws {
        // Arrange
        let expectedOutput = 132
        let version = "1.21.1"
        let apiURL = "https://api.papermc.io/v2/projects/paper/versions/\(version)"
        let apiUtils = APIutils()
        
        // Act
        if let data = apiUtils.fetchAPIData(using: apiURL) {
            if let latestBuild = apiUtils.findLatestBuild(from: data) {
                // Assert
                XCTAssertEqual(expectedOutput, latestBuild)
            } else {
                print("Could not find valid data.")
            }
        } else {
            print("Error while calling PaperMC API.")
        }
    }
    
    func testFetchLatestVelocityVersion() throws {
        // Arrange
        let expectedOutput = 461
        let version = "3.4.0-SNAPSHOT"
        let apiURL = "https://api.papermc.io/v2/projects/velocity/\(version)"
        let apiUtils = APIutils()
        
        // Act
        if let data = apiUtils.fetchAPIData(using: apiURL) {
            if let latestBuild = apiUtils.findLatestBuild(from: data) {
                // Assert
                XCTAssertEqual(expectedOutput, latestBuild)
            } else {
                print("Could not find valid data.")
            }
        } else {
            print("Error while calling PaperMC API.")
        }
    }
    
    func testFetchLatestVelocityServerVersion() throws {
        // Arrange
        let expectedOutput = "3.4.0-SNAPSHOT"
        let apiURL = "https://api.papermc.io/v2/projects/velocity"
        let apiUtils = APIutils()
        
        // Act
        if let data = apiUtils.fetchAPIData(using: apiURL) {
            if let latestVersion = apiUtils.findLatestVersion(from: data) {
                // Assert
                XCTAssertEqual(expectedOutput, latestVersion)
            } else {
                print("Could not find valid data.")
            }
        } else {
            print("Error while calling PaperMC API.")
        }
    }
    
    func testDownloadedServerSoftware() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let instanceVersion = "1.21.1"
        let instanceType = "paper"
        let build = 132
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        let _ = instanceManager.downloadServerSoftware(type: instanceType, version: instanceVersion, instanceName: instanceName, build: build)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/\(instanceType)-\(instanceVersion)-\(build).jar"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testDownloadVelocityServerSoftware() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let instanceVersion = "3.4.0-SNAPSHOT"
        let instanceType = "velocity"
        let build = 461
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        let _ = instanceManager.downloadServerSoftware(type: instanceType, version: instanceVersion, instanceName: instanceName, build: build)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/\(instanceType)-\(instanceVersion)-\(build).jar"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testCompleteDownload() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let instanceVersion = "1.21.1"
        let instanceType = "paper"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        instanceManager.completeDownload(type: instanceType, version: instanceVersion, instanceName: instanceName, memory: nil, nogui: true)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/\(instanceType)-\(instanceVersion)-132.jar"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    /*
    Disabled because of missing deployment method
    func testPluginDeployment() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let pluginURL = "https://mediafilez.forgecdn.net/files/5635/193/SimpleWarp.v.4.0.jar"
        let pluginName = "SimpleWarp.v.4.0.jar"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        let _ = instanceManager.deployPlugin(url: pluginURL, instanceName: instanceName)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/plugins/\(pluginName)"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    */
    
    func testEulaAccept() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let utils = Utils()
        let instanceName = "TestServer"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        try instanceManager.acceptEula(instanceName: instanceName)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/eula.txt"))
        XCTAssertEqual(utils.getFileContent(path: "./\(instanceName)/eula.txt"), "eula=true")
        
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testStartScript() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let utils = Utils()
        let instanceName = "TestServer"
        let instanceVersion = "1.21.1"
        let instanceType = "paper"
        let instanceBuildNumber = 132
        let memory = 1024
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        instanceManager.createStartScript(instanceName: instanceName, instanceType: instanceType, instanceVersion: instanceVersion, instanceBuild: instanceBuildNumber, memory: memory)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/start.sh"))
        XCTAssertEqual(utils.getFileContent(path: "./\(instanceName)/start.sh"), "java -Xms512M -Xmx\(memory)M -jar \(instanceType)-\(instanceVersion)-\(instanceBuildNumber).jar")
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testStartScriptWithoutGUI() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let utils = Utils()
        let instanceName = "TestServer"
        let instanceVersion = "1.21.1"
        let instanceType = "paper"
        let instanceBuildNumber = 132
        let memory = 1024
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        instanceManager.createStartScript(instanceName: instanceName, instanceType: instanceType, instanceVersion: instanceVersion, instanceBuild: instanceBuildNumber, memory: memory, nogui: true)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/start.sh"))
        XCTAssertEqual(utils.getFileContent(path: "./\(instanceName)/start.sh"), "java -Xms512M -Xmx\(memory)M -jar \(instanceType)-\(instanceVersion)-\(instanceBuildNumber).jar --nogui -o true")
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testOPPlayer() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let playerName = "myynah"
        let expectedOutput: [String] = [
            "[",
            "  {",
            "    \"uuid\": \"8da0cf49-9bb3-43be-8513-31968dd3cf48\",",
            "    \"name\": \"myynah\",",
            "    \"level\": 4,",
            "    \"bypassesPlayerLimit\": false",
            "  }",
            "]"
        ]
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        instanceManager.addOperator(instanceName: instanceName, playerName: playerName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/ops.json"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertEqual(lines, expectedOutput)
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testAllowlist() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let playerName = "myynah"
        let expectedOutput: [String] = [
            "[",
            "  {",
            "    \"uuid\": \"8da0cf49-9bb3-43be-8513-31968dd3cf48\",",
            "    \"name\": \"myynah\"",
            "  }",
            "]"
        ]
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        instanceManager.addAllowlist(instanceName: instanceName, playerName: playerName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/whitelist.json"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertEqual(lines, expectedOutput)
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testAllowlistEnabled() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let expectedLine = "white-list=true"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        try instanceManager.setServerProperty(property: ServerProperty.whiteList, value: "true", instanceName: instanceName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/server.properties"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertTrue(lines.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines) == expectedLine })
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testGamemode() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let expectedLine = "gamemode=creative"
        let gamemode = "creative"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        try instanceManager.setServerProperty(property: ServerProperty.gamemode, value: gamemode, instanceName: instanceName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/server.properties"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertTrue(lines.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines) == expectedLine })
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testDifficulty() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let expectedLine = "difficulty=hard"
        let difficulty = "hard"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        try instanceManager.setServerProperty(property: ServerProperty.difficulty, value: difficulty, instanceName: instanceName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/server.properties"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertTrue(lines.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines) == expectedLine })
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
    func testMotd() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let expectedLine = "motd=This is a test server"
        let motd = "This is a test server"
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        try instanceManager.setServerProperty(property: ServerProperty.motd, value: motd, instanceName: instanceName)
        
        // Assert
        let fileContents = try String(contentsOf: URL(fileURLWithPath: "./\(instanceName)/server.properties"), encoding: .utf8)
        let lines = fileContents.split(separator: "\n").map { String($0) }
        XCTAssertTrue(lines.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines) == expectedLine })
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
}
