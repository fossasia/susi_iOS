#!/bin/bash

set -e

# Update all external dependencies
curl https://cocoapods-specs.circleci.com/fetch-cocoapods-repo-from-s3.sh | bash -s cf
pod install
