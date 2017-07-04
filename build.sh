#!/bin/sh
xcodebuild test -workspace Susi.xcworkspace -scheme Susi -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.0' ONLY_ACTIVE_ARCH=NO | xcpretty -c || travis_terminate 1
