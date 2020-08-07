/// Progress
/// A simple command line tool for tracking your various projects and progress.
/// Inspired by https://news.ycombinator.com/item?id=23900582

import ArgumentParser
import Foundation
import TSCBasic
import TSCUtility

/// MARK: Commands

struct Progress: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Progress is a simple command line tool for tracking your various projects and progress.",
        subcommands: [Show.self, Add.self, Update.self, Delete.self]
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
        try validateProgress(progress)
    }

    func run() throws {
        let progressPercent = progress ?? 0.0
        if var projects = Storage.getProjects() {
            let newProject = Project(id: projects.count, name: name, progress: progressPercent, modificationDate: Date())
            projects.append(newProject)
            Storage.store(projects)
        } else {
            let newProject = Project(id: 0, name: name, progress: progressPercent, modificationDate: Date())
            Storage.store([newProject])
        }

        print("Created project with name \(name), progress \(progressPercent)")
    }
}

struct Update: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Updates a specific project with a given id."
    )

    @Argument(help: "The id of the project to update.")
    private var id: Int

    @Option(name: .shortAndLong,
            help: "The progress on the project to update. Must be between 0 and 100.")
    private var progress: Double?

    @Option(name: .shortAndLong,
            help: "The name of the project. Cannot be empty.")
    private var name: String?

    func validate() throws {
        try validateProjectId(id)
        try validateProgress(progress)
    }

    func run() throws {
        if var projects = Storage.getProjects() {
            if let p = progress {
                projects[id].progress = p
                projects[id].modificationDate = Date()
                Storage.store(projects)
            }

            if let n = name {
                projects[id].name = n
                Storage.store(projects)
            }
            printProject(projects[id])
        }
    }
}

struct Delete: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Deletes a project with a given id."
    )

    @Argument(help: "The id of the project to delete. You can find the project id with `progress show`")
    private var id: Int

    func validate() throws {
        try validateProjectId(id)
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

/// MARK: Validators

func validateProjectId(_ id: Int) throws {
    if let projects = Storage.getProjects() {
        if id > projects.endIndex {
            throw ValidationError("A project with that id does not exist.")
        }
    } else {
        throw ValidationError("You currently have no projects.")
    }
}

func validateProgress(_ progress: Double?) throws {
    if let p = progress {
        guard p >= 0 && p <= 100 else {
            throw ValidationError("'<progress>' must be between 0 and 100.")
        }
    }
}

/// MARK: Printing

func printProjects(_ projects: [Project]) {    
    for p in projects {
        printProject(p)
    }
}

func printProject(_ p: Project) {
    let stdoutStream = TSCBasic.stdoutStream
    let tc = TerminalController(stream: stdoutStream)

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    let dateString = dateFormatter.string(from: p.modificationDate)

    tc?.write("\(p.id). ", inColor: .grey, bold: false)
    tc?.write("\(p.name) ", inColor: .white, bold: true)
    tc?.write("(\(p.progress)%) ", inColor: .grey, bold: true)
    tc?.write("| \(dateString)", inColor: .grey, bold: false)
    tc?.endLine()
}

Progress.main()