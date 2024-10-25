FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common

RUN add-apt-repository ppa:neovim-ppa/stable

RUN apt-get update && apt-get install -y \
    texlive-full \
    zathura \
    neovim \
    inkscape \
    curl \
    git 

# Manually download and install Russian spell file for Vim
RUN mkdir -p ~/.local/share/nvim/site/spell && \
    curl -fLo ~/.local/share/nvim/site/spell/ru.utf-8.spl \
    http://ftp.vim.org/vim/runtime/spell/ru.utf-8.spl && \
    curl -fLo ~/.local/share/nvim/site/spell/ru.utf-8.sug \
    http://ftp.vim.org/vim/runtime/spell/ru.utf-8.sug

# Install VimPlug
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

COPY ./config/ /root/.config/

RUN nvim --headless +PlugInstall +qall

WORKDIR /home
CMD [ "/bin/bash" ]

