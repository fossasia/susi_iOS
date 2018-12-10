#!/bin/bash

set -e

curl -L --output SwiftLint.pkg --url http://github.com$(curl -s -L https://github.com/realm/SwiftLint/releases/latest | egrep -o '/realm/SwiftLint/releases/download/[0-9.]*/SwiftLint.pkg')
sudo installer -pkg SwiftLint.pkg -target /
