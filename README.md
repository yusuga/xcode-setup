# xcode-setup

# Required tools

- [Homebrew](https://brew.sh/index_ja)
- [bundler](https://rubygems.org/gems/bundler/versions/1.11.2): 2.0.2
    - Installation: `sudo gem install bundler:2.0.2`

**Dependences**

```
Homebrew
└─ Mint
   ├─ Carthage
   ├─ xcodegen
   ├─ swiftgen
   └─ swiftlint

bundler
└─ CocoaPods
```

# Usage

```sh
git clone git@github.com:yusuga/xcode-setup.git
cd xcode-setup/App
make
```