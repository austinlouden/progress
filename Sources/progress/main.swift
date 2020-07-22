/// Progress
/// A simple command line tool for tracking your various projects and progress.

import Foundation
import ArgumentParser

struct Progress: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Shows progress",
        subcommands: [Show.self]
    )

    init() {}
}

struct Show: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Show all projects."
    )

    func run() throws {
        print("Showing all projects")
    }

}

Progress.main()