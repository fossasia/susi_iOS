xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO test -workspace Susi.xcworkspace -scheme Susi -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.0' | xcpretty -c

