# Git Projects

Easily manage Git projects that usually have more than one remote repository.

## Presumptions

You are a developer who uses Git and contributes to multiple projects for work and/or open source.
If you haven't found an easy way to fetch changes for all your projects then this could help.
As developers we are familiar with commands for updating dependencies of our projects.
Rubyists use `bundle`, VIM users can similarly update using `:BundleInstall`, iOS developers use `pod install` and the list goes on.
With this project you can fetch changes using some commands like `git-projects update`.

## Limitations

### Be Careful

This project does not involve merging or updating branches. We're only concerned about managing repositories and remotes.
Remote branches can be merged after you update. There's nothing magical about this gem but takes away some pains.
If you're going to do something like `git reset --hard origin/master` without checking if that branch is the latest version or not, then it might give you some problems.
Be careful. Sometimes it's not useful to do `git push all --all`.

## Prerequisities

* Git
* Ruby 2.1.0 +
* Git projects

## Configuration

The app requires that you have a configuration file and a environment variable called `GIT_PROJECTS`.
You must create a configuration file manually. Use this `YAML` format:

```yaml
project1:
  origin: path/to/repo
  github: path/to/repo
  assembla: path/to/repo
  heroku: path/to/repo
project2:
  origin: path/to/repo
  github: path/to/repo
  assembla: path/to/repo
  heroku: path/to/repo
```

Regardless of whether you use bash or zsh, please add the path:

```bash
export GIT_PROJECTS=$(/path/to/git-projects.yml):$GIT_PROJECTS
```

If all of your projects reside in one directory, there's a convenient command for generating the configuration file:

`git-projects config /path/to/repositories`

## Cloning all repositories

This will clone all repositories:

`git-projects clone`


## Fetching changes from all remotes

This will fetch all changes for all remotes for all repositories:

`git-projects fetch`

## Maintainer

> Laziness is a virtue of a good programmer.

[Katherine Pe](http://c.kat.pe)
