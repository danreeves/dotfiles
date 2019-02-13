#!/bin/bash -

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
  grep '"tag_name":' |                                              # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/'                                      # Pluck JSON value
}

echo "Installing from apt"
sudo apt-get install -y \
	zsh \
	curl \
	unzip \
        wget \
	zsh-syntax-highlighting \
        python \
        python3 \
        python-pip \
        python3-pip \
        iputils-ping \
        tmux

echo "Installing git-town"
curl --silent -L "https://github.com/Originate/git-town/releases/download/$(get_latest_release Originate/git-town)/git-town-amd64.deb" -o git-town.deb
sudo dpkg -i git-town.deb
rm git-town.deb

echo "Installing pure prompt"
git clone https://github.com/intelfx/pure.git ~/.pure
mkdir -p ~/.zfunctions
ln -s ~/.pure/pure.zsh "$HOME/.zfunctions/prompt_pure_setup"
ln -s ~/.pure/async.zsh "$HOME/.zfunctions/async"

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

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
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

echo "Installing rls"
rustup component add rls-preview rust-analysis rust-src

echo "Installing ripgrep"
cargo install ripgrep

echo "Installing terraform"
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
sudo install terraform /usr/local/bin
rm terraform terraform_0.11.10_linux_amd64.zip

echo "Installing go"
wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar -xvf go1.11.4.linux-amd64.tar.gz
sudo mv ./go /opt/go
rm go1.11.4.linux-amd64.tar.gz

echo "Installing nvm"
mkdir ~/.nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.nvm/nvm.sh

echo "Installing node"
nvm install node
node --version

echo "Installing Heroku"
curl https://cli-assets.heroku.com/install.sh | sh

echo "Installing lua"
sudo apt install lua5.1 liblua5.1-dev
wget https://luarocks.org/releases/luarocks-3.0.4.tar.gz
tar zxpf luarocks-3.0.4.tar.gz
cd luarocks-3.0.4
./configure; sudo make bootstrap
cd ..
rm -rf luarocks-3.0.4
rm luarocks-3.0.4.tar.gz
luarocks intall --local formatter
