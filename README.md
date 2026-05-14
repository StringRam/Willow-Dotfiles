![📦 Downloads](https://img.shields.io/github/downloads/StringRam/Willow-Dotfiles/total?label=📦%20Downloads)
![📄 License](https://img.shields.io/github/license/StringRam/Willow-Dotfiles?label=📄%20License)
![⭐ Stars](https://img.shields.io/github/stars/StringRam/Willow-Dotfiles?label=⭐%20Stars)

# 🌿 Willow-Dotfiles


Willow-Dotfiles contains my personal Hyprland + Quickshell desktop environment configuration.

The project is themed around the idea of a willow tree:

- The vertical bar acts as the trunk.
- Top drop panels act as contextual branches.
- The side panel is used for personal and temporal organization.
- Toasts and temporary UI elements behave like ephemeral leaves.

This is currently a personal desktop project, not a polished public desktop environment.

---

## Current Status

**Stage:** active prototype / personal daily-driver experiment

The repo already contains working Hyprland, Quickshell, Kitty, Zsh, MPD, Rofi, and session-related configuration.  
However, several Quickshell modules are still experimental, partially mocked, or in need of cleanup.

Known limitations:
- Some UI modules are prototypes or partial implementations.
- Some files are personal-machine specific.
- Some Quickshell components still use hardcoded dimensions or colors.
- Some dashboard and sidepanel data is mocked.
- The installer is functional but still very opinionated.
- The dotfiles are currently applied with `stow .`, so the repo layout still needs refinement.

---

## Main Components
### Hyprland

Configuration for:
- Hyprland
- Hyprlock
- Hypridle
- Hyprpaper
- Keybindings
- Window rules
- Wallpaper scripts

Current files:

```txt
.config/hypr/
├── hyprland.conf
├── hypridle.conf
├── hyprlock.conf
├── hyprpaper.conf
├── keybindings.conf
├── windowrules.conf
├── wallpaper.sh
├── scripts/
└── Images/
```

---

### Quickshell

Custom shell written with Quickshell/QML.
Current structure:
```txt
.config/quickshell/
├── shell.qml
├── components/
├── config/
├── modules/
├── services/
└── utils/
```

Main areas:
```txt
components/     Reusable UI components
config/         Appearance and module configuration
modules/        Visible UI modules
services/       Shared state and system-facing logic
utils/          Utility files and experiments
```

Current modules include:
```txt
modules/
├── background/     # Wallpaper picker
├── bar/            # Vertical bar
├── dashboard/      # Dashboard prototype
├── drawers/        # Drop panels and overlay containers
├── launcher/       # App/window/run launcher
├── notifs/         # Toasts and notification content
└── sidepanel/      # Calendar / agenda prototype
```

Current services include:

```txt
services/
├── Apps.qml
├── Colours.qml
├── Ime.qml
├── Notifs.qml
├── Session.qml
├── Time.qml
├── Visibility.qml
├── Wallpapers.qml
└── Windows.qml
```

---

## Current Shell Features

Implemented or partially implemented:

- Vertical Hyprland bar
- Workspace indicator
- Clock widget
- Battery indicator
- System tray
- IME indicator
- Launcher overlay
- Wallpaper picker
- Notification toasts
- Notification panel content
- Silent/quiet notification behavior
- Dashboard prototype with tabs
- Sidepanel prototype
- Calendar/schedule mock UI
- Shared visibility service
- Wallpaper-derived color workflow in progress

Some of these features are still incomplete and should be treated as prototypes.

---

## Visual Direction

The design direction is organic, dark, and minimal.

Core ideas:

- Permanent UI should be scarce.
- The right-side vertical bar is the stable center of the shell.
- Temporary information should appear only when needed.
- Technical system information belongs in the dashboard.
- Personal/time organization belongs in the sidepanel.
- Notifications should feel transient and non-blocking.
- Wallpaper-based accent colors should influence the interface without overwhelming it.

Avoided direction:

- Large permanent widgets
- Overloaded bars
- Constant decorative noise
- Dashboard duplication inside the sidepanel
- Too many always-visible indicators

---

## Other Configs

The repo also contains configuration for:

```txt
.config/kitty/       # Kitty terminal
.config/rofi/        # Rofi theme/searchbar
.config/mpd/         # MPD config
.config/rmpc/        # RMPC config
.config/wlogout/     # Wlogout theme
.zshrc               # Zsh config
```

Local fonts are included under:

```txt
.config/fonts/
```

---

## Package Installation

Official packages are listed in:

```txt
pkglist.txt
```

The install script also installs a small set of AUR packages defined directly in:

```txt
dotfiles-install.sh
```

Current AUR packages include:

```txt
hyprpicker
safeeyes
visual-studio-code-bin
vesktop
zsh-theme-powerlevel10k-git
```

---

## Installation

This script is intended to be run after installing the base system, preferably after using Willow-Arch.

Clone the repository:
```sh
git clone https://github.com/StringRam/Willow-Dotfiles.git ~/Willow-Dotfiles
cd ~/Willow-Dotfiles
```

Make the installer executable:
```sh
chmod +x dotfiles-install.sh
```

Run it as your normal user:
```sh
./dotfiles-install.sh
```

Do not run it as root.

---
## Important Warning

These are personal dotfiles.
Before running the installer, be aware that it may:

- Overwrite or conflict with existing configuration files
- Change your login/session setup
- Change your default shell
- Install packages you may not want
- Apply the whole repository into `$HOME` using Stow

Recommended before installing:
```sh
cp -r ~/.config ~/.config.backup
cp ~/.zshrc ~/.zshrc.backup
```

Or inspect the repository and apply parts manually.

---
## Development Notes

The project currently needs cleanup in these areas:
- Separate personal configuration from reusable desktop configuration.
- Split package lists by profile.
- Avoid hardcoded monitor layouts.
- Move hardcoded colors and dimensions into shared config.
- Remove dead or obsolete QML files.
- Separate mock data from real services.
- Replace `stow .` with package/profile-based Stow targets.
- Improve documentation for active Quickshell modules.

---
## Contributing

Feedback, audits, and suggestions are welcome.
This is still a personal desktop environment, so contributions should respect the project direction: minimal permanent UI, organic visual identity, Quickshell-first shell design, and Hyprland-based workflow.

---
## License

MIT License  
© 2025 Mateo Correa Franco

Credits to the creators and maintainers of:
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [Quickshell](https://git.outfoxxed.me/outfoxxed/quickshell)
