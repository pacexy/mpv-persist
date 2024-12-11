# mpv-persist

Persist certain properties to the [directory-specific configuratoin file](https://mpv.io/manual/stable/#file-specific-configuration-files).

## Installation

Put `persist.lua` in mpv `scripts` directory.

For details, see [Script location - mpv.io](https://mpv.io/manual/stable/#script-location).

## Configuration

Put `persist.conf` in mpv `script-opts` directory.

For details, see [`mp.options` functions - mpv.io](https://mpv.io/manual/stable/#mp-options-functions).

### `props`

The `props` contains the list of properties to be persisted.

By default, the following properties are persisted:

- `volume`
- `sid`
- `sub-delay`
- `secondary-sid`
- `secondary-sub-delay`

## References

- [Configuration Files - mpv.io](https://mpv.io/manual/stable/#configuration-files)
- [File-specific Configuration Files - mpv.io](https://mpv.io/manual/stable/#file-specific-configuration-files)