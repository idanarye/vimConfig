git submodule foreach "git checkout `git branch | grep 'develop\|master' | sed 's/[* ]*//'`"
