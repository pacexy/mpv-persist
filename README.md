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

## References

- [File-specific Configuration Files - mpv.io](https://mpv.io/manual/stable/#file-specific-configuration-files)
