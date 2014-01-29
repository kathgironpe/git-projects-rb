# CHANGELOG

## git-projects 0.0.1 (January 28, 2014)

* Added a feature to clone all repositories given a config file exists.
* Added a feature to add remotes to repositories given a config file exists.
* After all remotes are added and the `all: true` option exists, remotes are added to `all` remote.
* Added a feature to automatically fetch changes from different remotes for a repository.

## git-projects 0.0.2 (January 29, 2014)

* Installation notes.
* Fixed a bug about cloning aborted if root_dir is missing for one project
* Added useful debugging messages
* Skip fetching from `all` remote
