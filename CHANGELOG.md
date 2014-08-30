# CHANGELOG

## git-projects 0.0.1 (January 28, 2014)

* Added a feature to clone all repositories given a config file exists.
* Added a feature to add remotes to repositories given a config file exists.
* After all remotes are added and the `all: true` option exists, remotes are added to `all` remote.
* Added a feature to automatically fetch changes from different remotes for a repository.

## git-projects 0.0.2 (January 29, 2014)

* Installation notes.
* Fixed a bug about cloning aborted if root_dir is missing for one project.
* Added useful debugging messages.
* Skip fetching from `all` remote.

## git-projects 0.0.3 (January 31, 2014)

* Fixed a bug that discontinues updates when remote has already been added.
* Renamed `clone` to `init`.
* Grouping projects is now possible with `git fetch group-name`. By default `git fetch` will still fetch changes from all repositories.
* Because of the grouping requirement, `git-projects config` was refactored to allow two arguments (path and group).
* Added `git-projects add-remotes`
* Added useful colors to distinguish errors from success messages.

## git-projects 0.0.4 (February 2, 2014)

* Removed the directory argument for `git-projects config`

## git-projects 0.0.5 (February 2, 2014)

* Removed output mentioning number of projects.

## git-projects 0.0.6 (July 7, 2014)

* Fixed logic and code style issues.

## git-projects 0.0.7 (July 11, 2014)

* Refactored helpers

## git-projects 0.0.8 (July 11, 2014)

* Fixed a regression

## git-projects 0.0.9 (August 30, 2014)

* Added the "all" remote
* Fixed Travis CI build
