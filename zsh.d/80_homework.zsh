function at_home {
sed -i '/use_proxy/ s,on,off,' $HOME/.wgetrc

sed -i '/proxy/ s,^,# ,' $HOME/.zshenv
sed -i '/proxy/ s,^,# ,' $HOME/.curlrc
sed -i '/proxy/ s,^,# ,' $HOME/.condarc
sed -i '/proxy/ s,^,# ,' $HOME/.npmrc
sed -i '/proxy/ s,^,# ,' $HOME/.pip/pip.conf
sed -i '/homework->here/{n;s/^/\# /;n;s/^/\# /}' $HOME/.subversion/servers

dconf write /system/proxy/mode "'none'"
git config --global http.proxy ""

unset http_proxy
unset https_proxy

sed -i '/type/ s,3,0,' $HOME/.local/share/data/Nextcloud/nextcloud.cfg

sudo sed -i '/proxy/ s,^,# ,' /etc/apt/apt.conf.d/80proxy
}

function at_work {
sed -i '/use_proxy/ s,off,on,' $HOME/.wgetrc

sed -i '/proxy/ s,\# ,,' $HOME/.zshenv
sed -i '/proxy/ s,\# ,,' $HOME/.curlrc
sed -i '/proxy/ s,\# ,,' $HOME/.condarc
sed -i '/proxy/ s,\# ,,' $HOME/.npmrc
sed -i '/proxy/ s,\# ,,' $HOME/.pip/pip.conf
sed -i '/homework->here/{n;s/^\# //;n;s/^\# //}' $HOME/.subversion/servers

dconf write /system/proxy/mode "'auto'"
git config --global http.proxy proxy.onera:80
export http_proxy="http://proxy.onera:80"
export https_proxy="https://proxy.onera:80"

sed -i '/type/ s,0,3,' $HOME/.local/share/data/Nextcloud/nextcloud.cfg

sudo sed -i '/proxy/ s,\# ,,' /etc/apt/apt.conf.d/80proxy
}

