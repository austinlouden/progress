/// Progress
/// A simple command line tool for tracking your various projects and progress.
/// Inspired by https://news.ycombinator.com/item?id=23900582

import Foundation
import ArgumentParser

struct Progress: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Progress is a simple command line tool for tracking your various projects and progress.",
        subcommands: [Show.self, Add.self, Delete.self]
    )

    init() {}
}

struct Show: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Shows all projects."
    )

    func run() throws {
        if let projects = Storage.getProjects() {
            printProjects(projects)
        } else {
            print("No projects to show. Add a new project with progress add <name>.")
        }
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
        if var projects = Storage.getProjects() {
            let newProject = Project(id: projects.count, name: name, progress: progress ?? 0)
            projects.append(newProject)
            Storage.store(projects)
        } else {
            let newProject = Project(id: 0, name: name, progress: progress ?? 0)
            Storage.store([newProject])
        }

        print("Created project with name \(name), progress \(progress ?? 0.0)")
    }
}

struct Delete: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Deletes a project with a given id."
    )

    @Argument(help: "The id of the project to delete. You can find the project id with `progress show`")
    private var id: Int

    func validate() throws {
        if let projects = Storage.getProjects() {
            if id > projects.endIndex {
                throw ValidationError("A project with that id does not exist.")
            }
        } else {
            throw ValidationError("You currently have no projects to delete.")
        }
    }

    func run() throws {
        if var projects = Storage.getProjects() {
            projects.remove(at: id)
            for i in 0..<projects.count {
                projects[i].id = i
            }
            Storage.store(projects)
            printProjects(projects)
        }
    }

}

func printProjects(_ projects: [Project]) {
    for p in projects {
        print("\(p.id)\t\(p.name)\t\t\(p.progress)%")
    }
}

Progress.main()