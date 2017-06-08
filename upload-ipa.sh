#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo "This is a pull request. No deployment will be done."
    exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
    echo "Testing on a branch other than master. No deployment will be done."
    exit 0
fi

APPNAME="Susi"
OUTPUTDIR="$PWD/build/Debug-iphoneos"

git config --global user.email "noreply@travis.com"
git config --global user.name "Travis CI"

echo "********************"
echo "*    Uploading     *"
echo "********************"

#create a new directory that will contain out generated ipa
mkdir $HOME/buildiPA/

#copy .ipa from build folder and README.md to the folder just created
cp -R @$OUTPUTDIR/$APPNAME.ipa $HOME/buildiPA/
cp -R README.md $HOME/buildiPA/

git clone --quiet --branch=ipa https://fossasia:$GITHUB_API_KEY@github.com/fossasia/susi_iOS ipa > /dev/null

cd ipa
cp -Rf $HOME/buildiPA/*  ./

git checkout --orphan workaround
git add -A

git commit -am "Travis build pushed [skip ci]"

git branch -D ipa
git branch -m ipa

#push to the branch ipa
git push origin ipa --force --quiet> /dev/null
