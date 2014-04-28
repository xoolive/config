# alias
git config --global alias.gl "log -12 --color=always --all --graph --topo-order --pretty='format:%Cgreen%h%Creset %s %C(black bold)(by %an)%Creset%C(yellow bold)%d%Creset%n'"
git config --global alias.ll "log -18 --color=always --all --topo-order --pretty='format:%Cgreen%h%Creset %s%Cred%d%Creset %C(black bold)(by %an)%Creset'"
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
