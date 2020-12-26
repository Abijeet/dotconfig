# dotconfig

Mainly consists of i3 configuration and some helper scripts.

Tested on a Asus Vivobook S15 2018 running Debian Bullseye.

# Setup
## Required software
1. [i3status-rs](https://github.com/greshake/i3status-rust)
2. [rofi](https://packages.debian.org/bullseye/rofi)

And other software's listed in the config folder.

TODO: Blog post link to follow

## Fonts
Primary fonts used:
1. [font-font-awesome](https://packages.debian.org/bullseye/fonts-font-awesome)
2. [Hack](https://github.com/source-foundry/Hack)
3. [FiraCode](https://github.com/tonsky/FiraCode)

## i3 configuration
Copy contents of the i3 folder to `~/.config/i3` folder.

### OpenWeather Map API Key
Put the API key in "weather" block inside `status.toml` file.

## Custom scripts
There are a few scripts written. These are in the `bin` folder.

Copy these over to `~/bin` folder.

## xbindkeys
Xbindkeys is used to configure the "multimedia/special" keys on the laptop

Copy contents of `xbindkeys` to home directory.

