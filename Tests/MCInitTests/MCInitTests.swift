import XCTest
@testable import MCInit

final class MCInitTests: XCTestCase {
    func testDirectoryCreation() throws {
        // Arrange
        let serverName = "TestServer"
        let directoryPath = "/tmp/\(serverName)"
        var command = try MCInit.parse([serverName])
        
        // Act
        let output = try captureOutput {
            try command.run()
        }
        
        // Assert
        XCTAssertTrue(FileManager.default.fileExists(atPath: directoryPath))
        XCTAssertEqual(output, "Initialized new server as \(serverName)")
    }
    
    private func captureOutput(_ closure: () throws -> Void) throws -> String {
        let originalStdout = dup(STDOUT_FILENO)
        let pipe = Pipe()
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        pipe.fileHandleForWriting.closeFile()
        
        defer {
            dup2(originalStdout, STDOUT_FILENO)
            close(originalStdout)
        }
        
        try closure()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        pipe.fileHandleForReading.closeFile()
        return String(data: data, encoding:  .utf8) ?? ""
    }
}
