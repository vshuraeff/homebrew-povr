# Homebrew Tap for povr

This tap distributes `povr`, a Pushover command-line client with native macOS notifications.

povr is an unofficial, independent client and is not affiliated with or endorsed by Pushover, LLC.

## Install

```sh
brew tap vshuraeff/povr && brew install povr
# or: brew install vshuraeff/povr/povr
```

Until `v0.1.0` is tagged, install the development version with:

```sh
brew install --HEAD vshuraeff/povr/povr
```

After installation and each upgrade, run `povr helper install` to enable native macOS notifications.
