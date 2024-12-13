# mpv-persist

Persist certain properties to the [directory-specific configuration file](https://mpv.io/manual/stable/#file-specific-configuration-files).

## Installation

1. Download `persist.lua`.
2. Place it in the `scripts` directory of your mpv installation.

For more details, see [Script location - mpv.io](https://mpv.io/manual/stable/#script-location).

## Configuration

1. Download `persist.conf`.
2. Place it in the `script-opts` directory of your mpv installation.

For more details, see [`mp.options` functions - mpv.io](https://mpv.io/manual/stable/#mp-options-functions).

### `props`

The `props` option contains the list of properties to be persisted.

By default, the following properties are persisted:

- `volume`
- `sid`
- `sub-delay`
- `secondary-sid`
- `secondary-sub-delay`

### How it works

1. Observes property changes.
2. Persists these properties.
3. Loads them on the `file-loaded` event, which is necessary to prevent [unexpected property resets](https://github.com/mpv-player/mpv/issues/13670).

## References

- [File-specific Configuration Files - mpv.io](https://mpv.io/manual/stable/#file-specific-configuration-files)
- [`reset-on-next-file` - mpv.io](https://mpv.io/manual/stable/#options-reset-on-next-file)
