# Warrantiak: Device Warranty Checker

> `warrantiak` is a shell script to check the warranty status of devices using their serial numbers. Currently, it supports Lenovo, HP, ASUS and DELL devices, with plans to add support for DELL and Apple in the future.

![Bez názvu](https://github.com/user-attachments/assets/3561ea43-1f43-4e93-8431-83da50e9c76a)

## Features

- Fetch device type and warranty information
- Display warranty start and end dates, product type, and model.
- Simple and easy-to-use command-line interface.
- Devices check: DELL, ASUS, HP, Lenovo

## Table of Contents

[**Screenshots**](#screenshots)

[**Usage**](#usage)

- [**Interactive**](#interactive)
- [**Non-interactive**](#non-interactive)
- [**Command-line arguments**](#command-line-arguments)

[**Installation**](#installation)

- [**UNIX and Linux**](#unix-and-linux)

[**System requirements**](#system-requirements)

- [**Dependencies**](#dependencies)

## Screenshots

![Bez názvu](https://github.com/user-attachments/assets/320155e8-1109-4e47-a27b-10316637342c)

## Usage

### Interactive

`warrantiak` has a built-in interactive menu that can be executed as such:

```bash
./warrantiak
```

### Non-interactive

For those who prefer to utilize command-line options, `warrantiak` also has a non-interactive mode supporting both short and long options:

```bash
./warrantiak <optional-command-to-execute-directly>
```

### Command-line arguments

Possible arguments in short and long form:

```bash
GENERATE OPTIONS
    -L, --lenovo-check
        check the warranty status of a Lenovo device
    -H, --hp-check
        check the warranty status of a HP device
    -D, --dell-check
        check the warranty status of a DELL device
    -A, --asus-check
        check the warranty status of a ASUS device
```

### Non-interactive S/N check

You can set the variable `_SERIAL_NUMBER`

```bash
export _SERIAL_NUMBER="SN123FOOBAR"
```

### JSON output

You can set the variable `_JSON_OUTPUT`

```bash
export _JSON_OUTPUT="true"
```

### UNIX and Linux

```bash
git clone https://github.com/be-lenka/warrantiak.git && cd warrantiak
sudo make install
```

For uninstalling, open up the cloned directory and run

```bash
sudo make uninstall
```

For update/reinstall

```bash
sudo make reinstall
```

## System requirements

- An OS with a Bash shell
- Tools we use:

```bash
awk
sed
basename
cat
column
date
echo
grep
head
printf
read
```

### Dependencies

- [`bsdextrautils`](https://packages.debian.org/sid/bsdextrautils) `apt install bsdextrautils`
- [`coreutils`](https://packages.debian.org/sid/coreutils) `apt install coreutils`
- [`gawk`](https://packages.debian.org/sid/gawk) `apt install gawk`
- [`grep`](https://packages.debian.org/sid/grep) `apt install grep`

## Contribution

Want to contribute? Great! First, read this page.

### Code reviews

All submissions, including submissions by project members, require review.</br>
We use GitHub pull requests for this purpose.

### Some tips for good pull requests

- Use our code </br>
  When in doubt, try to stay true to the existing code of the project.
- Write a descriptive commit message. What problem are you solving and what
  are the consequences? Where and what did you test? Some good tips:
  [here](http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message)
  and [here](https://www.kernel.org/doc/Documentation/SubmittingPatches).
- If your PR consists of multiple commits which are successive improvements /
  fixes to your first commit, consider squashing them into a single commit
  (`git rebase -i`) such that your PR is a single commit on top of the current
  HEAD. This make reviewing the code so much easier, and our history more
  readable.

### Formatting

This documentation is written using standard [markdown syntax](https://help.github.com/articles/markdown-basics/). Please submit your changes using the same syntax.

## Licensing

MIT see [LICENSE][] for the full license text.

[LICENSE]: https://github.com/be-lenka/warrantiak/blob/master/LICENSE

## TLDR

> If there if there is not this type off formatted output, please check your internet connection.
