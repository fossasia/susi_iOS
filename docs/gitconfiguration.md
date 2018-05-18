## Git commands
### Configuring remotes
When a repository is cloned, it has a default remote called `origin` that points to your fork on GitHub, not the original repository it was forked from. To keep track of the original repository, you should add another remote named `upstream`:<br />
1. Get the path where you have your git repository on your machine. Go to that path in Terminal using cd. Alternatively, Right click on project in Github Desktop and hit ‘Open in Terminal’.<br />
2. Run `git remote -v`  to check the status of current remotes, you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/susi_iOS.git(fetch)<br />
> origin    https://github.com/YOUR_USERNAME/susi_iOS.git(push)<br />
3. Set the remote of orignal repository as  `upstream`:<br />
`git remote add upstream https://github.com/fossasia/susi_iOS.git`<br />
4. Run `git remote -v`  again to check the status of current remotes, you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/susi_iOS.git  (fetch)<br />
> origin    https://github.com/YOUR_USERNAME/susi_iOS.git  (push)<br />
> upstream  https://github.com/fossasia/susi_iOS.git (fetch)<br />
> upstream  https://github.com/fossasia/susi_iOS.git (push)<br />
5. To update your local copy with remote changes, run the following:<br />
`git fetch upstream master`<br />
`git rebase  upstream/master`<br />
This will give you an exact copy of the current remote, make sure you don't have any local changes.<br />
6. Project set-up is complete.<br />
### Developing a feature
1. Make sure you are in the master branch `git checkout master`.<br />
2. Sync your copy `git pull --rebase upstream master`.<br />
3. Create a new branch with a meaningful name `git checkout -b branch_name`.<br />
4. Develop your feature on Xcode IDE  and run it using the simulator or connecting your own iphone.<br />
5. Add the files you changed `git add file_name` (avoid using `git add .`).<br />
6. Commit your changes `git commit -m "Message briefly explaining the feature"`.<br />
7. Keep one commit per feature. If you forgot to add changes, you can edit the previous commit `git commit --amend`.<br />
8. Push to your repo `git push origin branch-name`.<br />
9. Go into [the Github repo](https://github.com/fossasia/susi_iOS) and create a pull request explaining your changes.<br />
10. If you are requested to make changes, edit your commit using `git commit --amend`, push again and the pull request will edit automatically.<br />
11. If you have more than one commit try squashing them into single commit by following command:<br />
`git rebase -i HEAD~n `(having n number of commits).<br />
12. Once you've run a git rebase -i command, text editor will open with a file that lists all the commits in current branch, and in front of each commit is the word "pick". For every line except the first, replace the word "pick" with the word "squash".<br />
13. Save and close the file, and a moment later a new file should pop up in  editor, combining all the commit messages of all the commits. Reword this commit message into meaningful one briefly explaining all the features, and then save and close that file as well. This commit message will be the commit message for the one, big commit that you are squashing all of your larger commits into. Once you've saved and closed that file, your commits of current branch have been squashed together.<br />
14. Force push to update your pull request with command `git push origin branchname --force`.<br/>
