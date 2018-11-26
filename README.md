# DEPRECATED

Experiment was finished. Python version is easier to use and mantaine.

# qa

QA automation script

## Setup

- Run `make install` to install the script to `~/bin` folder
- Make sure `~/bin` is in `PATH` or move `qa` executable to any other location
- Start using it with `qa <command>`

## Environment variables

Some commands require specific environment variables to be set

Variable          | Description
------------------|--------------------------------------------------
`PROJECTS_BACKUP` | Path to pycharm-qa-projects local repository copy
`VM_USER`         | Ubuntu VM user name
`VM_PORT`         | Ubuntu VM SSH port
`VM_KEY`          | Path to Ubuntu VM SSH secret key
`VM_PATH`         | Path on Ubuntu VM to install PyCharm to

## Aliases

It's impossible to change the current directory of the parent shell when running
executable as `qa goto backups` due to sub-shell limitations. You either should
run the script with `. ~/bin/qa` or create aliases:

```bash
alias backup='. ~/bin/qa goto backup'
alias backups='. ~/bin/qa goto backups'
```

## Commands

Command                    | Description
---------------------------|----------------------------------------------------
`docker`                   | Remove docker containers, images, networks, volumes
`archive`                  | Archive pwd as zip and copy to the desktop
`clean <version>`          | Wipe IDE settings on macOS (e.g. `PyCharm2018.2`)
`deploy`                   | Untar gz IDE archive from desktop to Ubuntu VM
`save`                     | Copy pwd to the projects backup folder
`goto backups`             | cd backups folder
`goto backup <project_id>` | cd project backup (`py_123`, pwd basename if no ID)
`version`                  | Returns `qa` script version
