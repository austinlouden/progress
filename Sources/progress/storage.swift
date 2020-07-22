import Foundation

final class Storage {

    static let filename = "progress.json"

    /// MARK: Public

    /// Returns a non-empty array of projects, otherwise returns nil.
    static func getProjects() -> [Project]? {
        if let projects = Storage.retrieve(as: [Project].self), !projects.isEmpty {
            return projects
        } else {
            return nil
        }
    }

    static func store<T: Encodable>(_ object: T) {
        let url = getFilePath()
        let encoder = JSONEncoder()
    
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// MARK: Private

    private static func retrieve<T: Decodable>(as type: T.Type) -> T? {
        let url = getFilePath()
    
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)!")
        }
    }

    private static func getFilePath() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent(Storage.filename)
        } else {
            fatalError("Could not access the storage filepath.")
        }
    }
}
