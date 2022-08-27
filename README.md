# Example of building an Xcode project

## Requirements

- Xcode 13.4.1 (13F100)
- [Docker Desktop for Mac](https://docs.docker.com/get-docker/)

## Support architecture

- x86_64 (including as emulated by Rosetta2)
- arm64

## Dependences

```
Mint (in project directory)
├─ Carthage
├─ xcodegen
├─ swiftgen
└─ swiftlint

Docker
└─ CocoaPods
```

## Usage

```sh
git clone git@github.com:yusuga/xcode-setup.git
cd xcode-setup/App
make
```
