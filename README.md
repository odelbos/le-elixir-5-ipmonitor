# Synopsis

This repository is an Elixir learning exercise.

Disclaimer : Do not use this code in production.  
_... But I'm using it ... :)_

_(with all my repositories, the `le-` prefix mean `Learning Exercise`)_

### History

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