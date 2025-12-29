import Foundation

final class SaveStore {
    static let shared: SaveStore = SaveStore()

    private init() {}

    private var fileURL: URL {
        let fm: FileManager = .default
        let base: URL = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir: URL = base.appendingPathComponent("ProjectElysium", isDirectory: true)

        if !fm.fileExists(atPath: dir.path) {
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        return dir.appendingPathComponent("save.json")
    }

    func load() -> GameState {
        do {
            let data: Data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(GameState.self, from: data)
        } catch {
            return GameState.freshDefault()
        }
    }

    func save(_ state: GameState) {
        do {
            let data: Data = try JSONEncoder().encode(state)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            // deliberate: minimal UX for now; later we’ll surface a non-blocking error banner
        }
    }
}
