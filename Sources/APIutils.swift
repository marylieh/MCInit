import Foundation

class APIutils {
    
    func fetchAPIData(using url: String) -> Data? {
        let process = Process()
        let pipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["curl", "-s", url]
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return data
        } catch {
            print("Error while running curl: \(error.localizedDescription)")
            return nil
        }
    }
    
    func findLatestBuild(from data: Data) -> Int? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let builds = json["builds"] as? [Int] {
                return builds.max()
            }
        } catch {
            print("Error while parsing JSON response: \(error.localizedDescription)")
        }
        return nil
    }
    
}
