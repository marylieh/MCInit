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
    
    func testDownloadedServerSoftware() throws {
        // Arrange
        let instanceManager = InstanceManager()
        let instanceName = "TestServer"
        let instanceVersion = "1.21.1"
        let instanceType = "paper"
        let build = 132
        
        // Act
        try FileManager.default.createDirectory(atPath: "./\(instanceName)", withIntermediateDirectories: true)
        let result = instanceManager.downloadServerSoftware(type: instanceType, version: instanceVersion, instanceName: instanceName, build: build)
        print(result)
        
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
        instanceManager.completeDownload(type: instanceType, version: instanceVersion, instanceName: instanceName, memory: nil)
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: "./\(instanceName)/\(instanceType)-\(instanceVersion)-132.jar"))
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
    
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
        XCTAssertEqual(utils.getFileContent(path: "./\(instanceName)/start.sh"), "java -Xms512M -Xmx\(memory)M -jar \(instanceType)-\(instanceVersion)-\(instanceBuildNumber).jar --nogui -o true")
        
        // Cleanup
        try FileManager.default.removeItem(atPath: "./\(instanceName)")
    }
}
