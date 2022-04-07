# iProcrastinay

### *Say nay to post compile-time procrastination!*

Get system notifications when your build is finished and save little by little time every day.

- on **macOS** or **Linux**
- **Maven** & **Gradle** supported
- in-console and via IDE builds
- works with [Maven Daemon](https://github.com/apache/maven-mvnd) out of the box

<img src="./resources/notification.gif" width="800"/>

### How it works

During the installation your Java executable is wrapped up in a shell script which takes
care about everything. No magic, no plugins, just a plain shell scripting.

### Prerequisites
- MacOS: [terminal-notifier](https://github.com/julienXX/terminal-notifier) installed (`brew install terminal-notifier`)
- Linux: [notify-send](https://ss64.com/bash/notify-send.html) installed

### Installation

Clone this repository using git or just download the installation script:
```commandline
curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/install.sh --output install.sh
```

Then run it using one of the following modes:

- simple mode (sufficient in most cases): `./install.sh` (no parameters)
  - tweaks your Java set in JAVA_HOME environment variable
- SDKMAN mode: `./install.sh --sdkman`
  - tweaks all your Java instances installed via [SDKMAN](https://sdkman.io/) utility
- custom paths mode: `./install.sh /path/to/java1 /path/to/java2 ...`
  - tweaks all you Java instances under provided absolute paths (pointing to `bin` directory parent)