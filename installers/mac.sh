#!/bin/bash -

echo "Setting kitty config dir"
launchctl setenv KITTY_CONFIG_DIRECTORY $HOME/.config/kitty/

echo "Installing Brewfile"
brew bundle

echo "Installing awscli@1"
brew install awscli@1

echo "Installing pure prompt"
git clone https://github.com/intelfx/pure.git ~/.pure
mkdir -p ~/.zfunctions
ln -s ~/.pure/pure.zsh "$HOME/.zfunctions/prompt_pure_setup"
ln -s ~/.pure/async.zsh "$HOME/.zfunctions/async"

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

echo "Installing vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Installing rls"
rustup component add rls rust-analysis rust-src

echo "Installing ripgrep"
cargo install ripgrep

echo "Installing node and lua"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf plugin-add luaJIT https://github.com/smashedtoatoms/asdf-luaJIT.git


asdf install nodejs 14.6.0
asdf install luaJIT 2.4.4
