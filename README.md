[![Gem Version](http://img.shields.io/gem/v/git-projects.svg)](https://rubygems.org/gems/git-projects)
[![Dependency Status](https://gemnasium.com/katgironpe/git-projects.svg)](https://gemnasium.com/katgironpe/git-projects)
[![Code Climate](https://codeclimate.com/github/katgironpe/git-projects.png)](https://codeclimate.com/github/katgironpe/git-projects)
[![Build Status](https://travis-ci.org/katgironpe/git-projects.svg?branch=master)](https://travis-ci.org/katgironpe/git-projects)

# Git Projects

Easily manage Git projects that usually have more than one remote repository.

## Presumptions

You are a developer who uses Git and contributes to multiple projects for work and/or open source.
If you haven't found an easy way to fetch changes for all your projects then this could help.
As developers we are familiar with commands for updating dependencies of our projects.
Rubyists use `bundle`, VIM users can similarly update using `:BundleInstall`, iOS developers use `pod install` and the list goes on.
With this project you can fetch changes using some commands like `git-projects fetch`.

## Limitations

### Be Careful

This project does not involve merging or updating branches. We're only concerned about managing repositories and remotes.
Remote branches can be merged after you update. There's nothing magical about this gem but takes away some pains.
If you're going to do something like `git reset --hard origin/master` without checking if that branch is the latest version or not, then it might give you some problems.
Be careful. Sometimes it's not useful to do `git push all --all`.

## Prerequisities

* Git
* Ruby 2.0.0 +
* Git projects

## Installation

You can use this globally without having install with `sudo` if you use something like `rvm 2.1.2 --default`.

```bash
gem install git-projects
```

## Configuration

The app requires that you have a configuration file and a environment variable called `GIT_PROJECTS`.
You must create a configuration file manually. Use this `YAML` format:

```yaml
project1:
  origin: path/to/repo
  github: path/to/repo
  assembla: path/to/repo
  bitbucket: path/to/repo
  heroku: path/to/repo
  root_dir: path/to/root_dir #where your repository will be cloned
  group: name # useful if you do not want to fetch changes for all
project2:
  origin: path/to/repo
  assembla: path/to/repo
  github: path/to/repo
  bitbucket: path/to/repo
  heroku: path/to/repo
  root_dir: path/to/root_dir #where your repository will be cloned
  group: web
```

Regardless of whether you use bash or zsh, please add the path:

```bash
export GIT_PROJECTS=$(/path/to/git-projects.yml)
```

If all of your projects reside in one directory, there's a convenient command for generating the configuration file:

```bash
cd /path/to/repositories
git-projects config
```

It could be helpful to a group as sometimes we do not want to fetch changes for all.
By default the group name is the name of the directory where your repository resides.
You can change that by specifying the group this way:

```bash
cd /path/to/repositories
git-projects config web
```

## Checking or initializing all repositories

This will check if repositories are cloned. Otherwise, it will initialize the repository and add the remotes.

```bash
git-projects init
```

## Fetching changes from all remotes

This will fetch all changes for all remotes for all repositories:

```bash
git-projects fetch
```

## Fetching changes for  a group

This will fetch all changes for repositories with group called `group-name`:

```bash
git-projects fetch group-name
```

## Adding remotes

If you added a new remote by editing the config file, you might want to add to make sure it's added to the repository as well:

```bash
git-projects add-remotes
```


## Maintainer

<a href="http://c.kat.pe" target="_blank">Katherine Pe</a>
