#!/bin/bash -

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
  grep '"tag_name":' |                                              # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/'                                      # Pluck JSON value
}

echo "Installing from apt"
sudo apt-get install -y \
  gettext \
  libgettextpo-dev \
  zsh \
  curl \
  unzip \
  wget \
  python \
  python3 \
  python-pip \
  python3-pip \
  iputils-ping \
  tmux

echo "Installing git-town"
curl --silent -L "https://github.com/git-town/git-town/releases/download/v7.3.0/git-town-amd64.deb" -o git-town.deb
sudo dpkg -i git-town.deb
rm git-town.deb

echo "Installing pure prompt"
git clone https://github.com/intelfx/pure.git ~/.pure
mkdir -p ~/.zfunctions
ln -s ~/.pure/pure.zsh "$HOME/.zfunctions/prompt_pure_setup"
ln -s ~/.pure/async.zsh "$HOME/.zfunctions/async"

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

echo "Installing neovim"
curl --silent -L \
  "https://github.com/neovim/neovim/releases/download/$(get_latest_release neovim/neovim)/nvim.appimage" \
	-o nvim.appimage \
	&& chmod u+x ./nvim.appimage \
	&& ./nvim.appimage --appimage-extract \
	&& sudo rm -rf /opt/nvim \
	&& sudo mv ./squashfs-root /opt/nvim \
	&& sudo ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim || true \
	&& rm ./nvim.appimage

echo "Installing python for neovim"
pip2 install --user neovim
pip3 install --user neovim

echo "Installing vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing diff-so-fancy"
sudo curl --silent -L https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o /usr/local/bin/diff-so-fancy \
	&& sudo chmod +x /usr/local/bin/diff-so-fancy

echo "Installing fasd"
git clone https://github.com/clvv/fasd.git /tmp/fasd
cd /tmp/fasd
sudo make install PREFIX=/usr
rm -rf /tmp/fasd

echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Installing rls"
rustup component add rls rust-analysis rust-src

echo "Installing ripgrep"
cargo install ripgrep

echo "Installing asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
chmod +x ~/.asdf/asdf.sh
source ~/.asdf/asdf.sh

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf plugin-add luaJIT https://github.com/smashedtoatoms/asdf-luaJIT.git

asdf install luaJIT 2.4.4
asdf install nodejs 12.18.3

# clipboard support in WSL
curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
mkdir ~/bin
mv /tmp/win32yank.exe ~/bin/win32yank.exe
