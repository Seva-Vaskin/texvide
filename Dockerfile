FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    texlive-full \
    zathura \
    inkscape \
    curl \
    git \
    tar 

# Install Node.js (required by coc.nvim)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz

ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Install python dependencies
# TODO: move
RUN apt-get install -y \
    python3-venv

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install pynvim
ENV PATH="/opt/venv/bin:$PATH"

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

# Ensure clipbaord synchronization
# TODO: move
RUN apt-get install -y xclip ripgrep ruby-dev cpanminus build-essential libssl-dev libreadline-dev zlib1g-dev


# Add locale support
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN npm install -g neovim
RUN gem install neovim
RUN cpanm --force Neovim::Ext IO::Async MsgPack::Raw Eval::Safe
RUN cpan App::cpanminus


# TODO: move
RUN apt-get install -y xdotool

WORKDIR /home
CMD [ "/bin/bash" ]
