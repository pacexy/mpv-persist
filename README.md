# mpv-persist

Persist certain properties to the directory-specific configuratoin file.

## Installation

Copy `persist.lua` to your mpv `scripts` directory.

## Usage

The script automatically saves the specified properties when a file is loaded and restores them when a file from the same directory is played again.

### Properties

By default, the following properties are persisted:

- `volume`
- `sid`
- `sub-delay`
- `secondary-sid`
- `secondary-sub-delay`

You can modify this list by using a configuration file `persist.conf`.

### Configuration File

You can also specify the properties to be saved/loaded using a configuration file `persist.conf`:
