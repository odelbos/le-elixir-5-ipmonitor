# Synopsis

This repository is an Elixir learning exercise.

Disclaimer : Do not use this code in production.  
_... But I'm using it ... :)_

_(with all my repositories, the `le-` prefix mean `Learning Exercise`)_

### Story

In my back country house there isn't any DSL, fiber and so on for Internet connection. So, I'm running the local network over a 4G modem. The public IP is changing frequently and I need to update some remote services configuration who have IP restriction access. I wanted to automate the process, here came up a nice little subject for having fun with `Elixir`.

## Subject of the exercise

The subject of this exercice is to monitor the public IP of the local machine and when the IP change :

- send a `Pushover` alert,
- execute system commands.

# Setup

Clone the repository and get the dependencies :

```bash
git clone git@github.com:odelbos/le-elixir-5-ipmonitor.git ip_monitor
cd ip_monitor
mix deps.get
```

Configure the settings :

```bash
cd config
cp SAMPLE.settings.yml settings.yml
chmod 600 settings.yml
```

Edit the `settings.yml` file to suit your need.

# Run

```bash
mix run --no-halt
```

# Settings

```yaml
monitor:
  every: 5mn                        # Check if ip has changed every 5mn
                                    # (format can be: 10mn or 2h)

services:
  getip:
    url: "https://ifconfig.me/ip"   # The external service to get the current public IP

  pushover:
    enable: true          # Set it to 'false' if you don't want to use Pushover service
    url: "https://api.pushover.net//1/messages.json"
    user: "--your user-key--"
    token: "--your-token--"

tasks:
  - name: "cmd1"
    cmd: "ls"
    params: ["-a", "-l", "/tmp"]

  - name: "cmd2"
    cmd: "du"
    params: ["-h", "-d 1", "/tmp"]

# If you don't want to execute any command, simply set an empty array, like so :
# tasks: []
#
# The 'tasks' entry is required
```
