#!/bin/bash

if [[ $CIRCLE_BRANCH != pull* ]]
then
        git config --global user.name "chashmeetsingh"
        git config --global user.email "chashmeetsingh@gmail.com"
        git clone --quiet --branch=ipa https://chashmeetsingh:$GITHUB_API_KEY@github.com/fossasia/susi_iOS ipa > /dev/null
        ls

        cp -r $HOME/Library/Developer/Xcode/DerivedData/Susi-*/Build/Products/Debug-iphonesimulator/Susi.app ipa/Susi.app
        cd ipa
        mkdir Payload
        mv Susi.app Payload/
        zip -r Payload.zip Payload
        mv Payload.zip Susi.ipa
        rm -rf Payload/
        ls

        git rm -rf * *.* .travis.yml .github .gitignore
        ls
        git add .

        git commit -am "[Circle CI] Update Susi.app"

        git branch -D ipa
        git branch -m ipa

        git push origin ipa --force --quiet > /dev/null
fi
