<img src="https://images.squarespace-cdn.com/content/v1/5ad5802f5cfd790758c31f75/1595539664836-V8GCANRP1SMLBPW76QCZ/ke17ZwdGBToddI8pDm48kIoaPtgIyHAVrwNYJPXWYLRZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIDHEXet5SJZ2b_-fg3i9L0GrygK0aXt4dJPAhm41PjP0/progress_logo.png?format=300w" width="80" height="80">

### About

Progress is terminal-based project tracking tool. It's designed to help keep track of longer-term projects — things that take a month or several months to complete.

### Installation

The following will install `progress` to `/usr/local/bin`.

```
git clone https://github.com/austinlouden/progress.git
cd progress
make
```

Optionally, add `progress show` to the bottom of your `.bashrc` or `.zshrc`
```
progress show
```

### Usage

Example commands:

- Add a new project, with 5% completed.
```
progress add "Your new project name" -p 5
```

- Update the progress on project with `id` 3 to 65%
```
progress update 3 -p 65
```

- Delete a project with `id` 2
```
progress delete 2
```

- Full usage output:
```
progress --help

USAGE: progress <subcommand>

SUBCOMMANDS:
-  `show`                    Shows all projects.
-  `add`                     Adds a new project with a given name an optional completion percentage.
-  `update`                  Updates a specific project with a given id.
-  `delete`                  Deletes a project with a given id.
```

### Screenshots

![progress](https://i.imgur.com/mexrbSt.png)
