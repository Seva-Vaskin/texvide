ARG PLATFORM=linux/amd64

FROM --platform=$PLATFORM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    texlive-full

RUN apt-get install -y \
    zathura \
    inkscape \
    curl \
    git \
    tar \
    python3-venv \
    xclip \
    ripgrep \
    ruby-dev \
    cpanminus \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    xdotool \
    locales \
    dbus-x11 \ 
    libglib2.0-0

# Install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Install Python packages
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install \
        pynvim \
        neovim-remote
ENV PATH="/opt/venv/bin:$PATH"

# Set env variables required by neovim-remote
ENV NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Manually download and install Russian spell file for Vim
RUN mkdir -p ~/.local/share/nvim/site/spell && \
    curl -fLo ~/.local/share/nvim/site/spell/ru.utf-8.spl \
    http://ftp.vim.org/vim/runtime/spell/ru.utf-8.spl && \
    curl -fLo ~/.local/share/nvim/site/spell/ru.utf-8.sug \
    http://ftp.vim.org/vim/runtime/spell/ru.utf-8.sug

# Install VimPlug
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Add locale support
RUN locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN npm install -g neovim
RUN gem install neovim
RUN cpanm --force Neovim::Ext IO::Async MsgPack::Raw Eval::Safe 
RUN cpan App::cpanminus

# Copy config files
COPY ./config/ /root/.config/

# Install plugins
RUN nvim --headless +PlugInstall +qall

WORKDIR /home
CMD [ "/bin/bash" ]
