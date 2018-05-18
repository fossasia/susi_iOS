#!/bin/sh
if [[ $CIRCLE_BRANCH != pull* ]]
then
        git config --global user.name "chashmeetsingh"
        git config --global user.email "chashmeetsingh@gmail.com"
        git clone --quiet --branch=ipa https://chashmeetsingh:$GITHUB_API_KEY@github.com/fossasia/susi_iOS ipa > /dev/null
        ls

        cd ipa

        # Delete all stale files
	find . -path ./.git -prune -o -exec rm -rf {} \; 2> /dev/null
	git add .

        # temporary commit to persist delete file changes
        git commit -m "temp"

        # Checkout a temporary branch to delete original ipa branch later
        git checkout --orphan temp

        cp -r $HOME/Library/Developer/Xcode/DerivedData/Susi-*/Build/Products/Debug-iphonesimulator/Susi.app Susi.app
        mkdir Payload
        mv Susi.app Payload/
        zip -r Payload.zip Payload
        mv Payload.zip Susi.ipa
        rm -rf Payload/
        ls -a

	# Add the SUSI ipa
        git add Susi.ipa

        git commit -am "[Circle CI] Updated Susi.ipa"
        
        # Delete original ipa branch
        git branch -D ipa

        # Rename 'temp' branch to ipa
        git branch -m ipa

        # Perform force push since histories are unrelated
        git push origin ipa --force --quiet > /dev/null
fi
