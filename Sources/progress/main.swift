/// Progress
/// A simple command line tool for tracking your various projects and progress.

import Foundation
import ArgumentParser

struct Progress: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Shows progress",
        subcommands: [Show.self, Add.self]
    )

    init() {}
}

struct Show: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Show all projects."
    )

    func run() throws {
        print("Showing all projects")

        let proj1 = Project(id: 0, name: "test", progress: 99.0)
        print(proj1)
    }
}

struct Add: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Adds a new project."
    )

    @Argument(help: "The name of the new project.")
    private var name: String

    @Option(name: .shortAndLong,
            help: "The amount of progress on the new project. Defaults to 0.0. Must be between 0 and 100.")
    private var progress: Double?

    func validate() throws {
        if let p = progress {
            guard p >= 0 && p <= 100 else {
            throw ValidationError("'<progress>' must be between 0 and 100.")
            }
        }
    }

    func run() throws {
        print("Creating project with name \(name)")
        print("Progress was given as \(progress ?? 0.0)")
    }
}

Progress.main()