#!/bin/bash - 

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
  grep '"tag_name":' |                                              # Get tag line
  sed -E 's/.*"([^"]+)".*/\1/'                                      # Pluck JSON value
}

echo "Installing from apt"
sudo apt-get install \
	zsh-syntax-highlighting

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
	&& sudo ln -s /opt/nvim/usr/bin/nvim /usr/bin/nvim || true \
	&& rm ./nvim.appimage

echo "Installing diff-so-fancy"
sudo curl --silent -L https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o /usr/bin/diff-so-fancy \
	&& sudo chmod +x /usr/bin/diff-so-fancy

echo "Installing fasd"
git clone https://github.com/clvv/fasd.git /tmp/fasd
cd /tmp/fasd
sudo make install PREFIX=/usr
rm -rf /tmp/fasd
