# PlaceOS Local

<img align="right" src="https://github.com/placeos.png?size=200" alt="PlaceOS" />

[![CI](https://github.com/PlaceOS/local/actions/workflows/ci.yml/badge.svg)](https://github.com/PlaceOS/local/actions/workflows/ci.yml)

For use when testing, improving or experimenting with PlaceOS on a local machine.

**Treat it as insecure** as it is *NOT* intended for production use...

## Table of Contents

<!-- Generated with `mdtoc --inplace` -->
<!-- See https://github.com/kubernetes-sigs/mdtoc -->
<!-- toc -->
- [PlaceOS Local](#placeos-local)
  - [Table of Contents](#table-of-contents)
  - [Drivers](#drivers)
  - [Installation](#installation)
    - [Dependencies](#dependencies)
      - [Optional tools](#optional-tools)
    - [MacOS](#macos)
  - [Configuration](#configuration)
  - [Usage](#usage)
    - [`$ placeos`](#-placeos)
    - [`$ placeos start`](#-placeos-start)
    - [`$ placeos stop`](#-placeos-stop)
    - [`$ placeos task`](#-placeos-task)
    - [`$ placeos changelog`](#-placeos-changelog)
    - [`$ placeos update`](#-placeos-update)
    - [`$ placeos upgrade`](#-placeos-upgrade)
    - [`$ placeos migrate`](#-placeos-migrate)
    - [`$ placeos uninstall`](#-placeos-uninstall)
  - [Service Graph](#service-graph)
<!-- /toc -->

## Drivers

See the [PlaceOS Drivers repository](https://github.com/PlaceOS/drivers) for further information.

## Installation

- Via `curl`:
  ```shell-session
  curl \
    --proto '=https' --tlsv1.2 \ # Enforce strict HTTPS
    --location \                 # Follow redirects
    --show-error --silent \      # Show an error message on failure
    --fail \                     # Fail on HTTP errors
    https://raw.githubusercontent.com/PlaceOS/local/master/scripts/install | bash
  ```

  In other words...

  ```shell-session
  curl --proto '=https' --tlsv1.2 -LsSf https://raw.githubusercontent.com/PlaceOS/local/master/scripts/install | bash
  ```

- Via `wget`:
  ```shell-session
  wget -O - https://raw.githubusercontent.com/PlaceOS/local/master/scripts/install | bash
  ```

### Dependencies

These will need to be installed prior to installation:

- [bash >= 4.4.20](https://www.gnu.org/software/bash)
- [docker >= 18.06.0](https://docs.docker.com/engine/install)
- [git >= 2.27.0](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

#### Optional tools

- [lazydocker](https://github.com/jesseduffield/lazydocker) for easy docker monitoring.
- [docker completion](https://docs.docker.com/compose/completion/) for more efficient terminal use.

### MacOS

If using [Docker Desktop for Mac](https://docs.docker.com/desktop/mac/install/), the default memory allocation of 2GB is insufficient for
running Elasticsearch in addition to the set of PlaceOS services.
Bumping the resource limit to 4GB should be sufficient.

## Configuration

- `PLACE_EMAIL`, `PLACE_PASSWORD`: Create an initial admin user via these environment variables
- `PLACE_DOMAIN`: Set an alternate application domain, defaults to `localhost:8443`

These environment variables can also be passed via the cli.

## Usage

When finished, stop the environment's containers with `placeos stop`.

### `$ placeos`

```shell-session
Usage: placeos [-h|--help] [--version] [command]

Helper script for interfacing with PlaceOS Local.

Command:
    start                   Start the environment.
    stop                    Stops the environment.
    task                    Runs a task in the environment.
    changelog               Displays platform changelog (in markdown).
    update                  Update the platform version.
    upgrade                 Upgrade PlaceOS Local.
    uninstall               Uninstalls PlaceOS Local.
    version                 Render PlaceOS version in use.
    help                    Display this message.

Arguments:
    --version               Render PlaceOS version in use.
    -h, --help              Display this message.
```

### `$ placeos start`

```shell-session
Usage: placeos start [-h|--help] [flags...]

Start the PlaceOS Local environment.

Arguments:
    --email EMAIL           Email to setup an admin account for. [default: support@place.tech]
    --password PASSWORD     Password for created admin account.
    --application APP_NAME  Application to configure. [default: backoffice]
    --domain DOMAIN         Domain to configure. [default: localhost:8443]
    --hard-reset            Reset the environment to a default state.
    --lgtm                  Enable and use Grafana LGTM stack
    --llama                 Enable and start ollama and open-webui
    -v, --verbose           Write logs to STDOUT in addition to the log file.
    -h, --help              Display this message
```

### `$ placeos stop`

```shell-session
Usage: placeos stop [-h|--help]

Stop the PlaceOS Local environment.

Arguments:
    -v, --verbose           Write logs to STDOUT in addition to the log file.
    -h, --help              Display this message.
```

### [`$ placeos task`](https://github.com/PlaceOS/init/#scripts)

```shell-session
Usage: placeos task [-h|--help|help] [--list] <task> [help|...] [arguments...]

Run a task in the PlaceOS Local environment.

Arguments:
    --list                  Display list of available tasks.
    -h, --help              Display this message.
```

### `$ placeos changelog`

```shell-session
Usage: placeos changelog [-h|--help] [--full] [VERSION]

Changelog for the PlaceOS.
If called without a VERSION, fetches the latest CHANGELOG entry.
Otherwise, fetches the CHANGELOG entry for passed VERSION.

Arguments:
    --full                  Include all prior CHANGELOG entries.
    -h, --help              Display this message
```

### `$ placeos update`

```
Usage: placeos update [-h|--help] [flags...] [VERSION]

Modifies PLACEOS_TAG to the selected PlaceOS platform version.
If VERSION is omitted, defaults to the most recent stable version.

Arguments:
    --list                  List the available versions.
    -v, --verbose           Write logs to STDOUT in addition to the log file.
    -h, --help              Display this message.
```

### `$ placeos upgrade`

```
Usage: placeos upgrade [-h|--help] [flags...] [VERSION]

Upgrades the PlaceOS Local environment.
If VERSION is omitted, defaults to the most recent stable version.

Arguments:
    --list                  Lists versions of PlaceOS Local.
    -q, --quiet             Do not write command logs to STDOUT.
    -h, --help              Display this message.
```

### `$ placeos migrate`

```shell-session
Usage: placeos migrate

Run a RethinkDB data migration in the local environment.

Arguments:
    -a, --appends           Don't clean tables before loading RethinkDB data. Defaults to True
    -h, --help              Display this message.
```

### `$ placeos uninstall`

```shell-session
Usage: placeos uninstall [-h|--help] [--force]

Removes PlaceOS containers, removes scripts from paths, and finally deletes the installation path.

Arguments:
    --force                 Skip confirmation of uninstall.
    -h, --help              Display this message.
```

## Service Graph

![Service graph for PlaceOS](/images/service-graph.png)
