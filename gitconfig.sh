# alias
git config --global alias.lol "log --pretty=oneline --abbrev-commit --graph --decorate"
git config --global alias.los "log --pretty=oneline --abbrev-commit -10 --decorate"
git config --global alias.root "rev-parse --show-toplevel"
git config --global alias.up '!git remote update -p; git merge --ff-only @{u}'

# color
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto

# other
git config --global core.editor vim
git config --global user.email "xavier@xoolive.org"
git config --global user.name "Xavier Olive"

# how to push (branch)
git config --global push.default simple
git config --global pull.ff only
