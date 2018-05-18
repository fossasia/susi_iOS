#!/bin/bash

xcodebuild clean build-for-testing \
    -workspace Susi.xcworkspace \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.2' \
    -scheme Susi | xcpretty -c && exit ${PIPESTATUS[0]}
