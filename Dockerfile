# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install locales package and generate locales
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Set locale environment variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libtool-bin \
    ninja-build \
    pkg-config \
    gettext \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    ruby-dev \
    cpanminus \
    zathura \
    inkscape \
    texlive-full \
    xclip \
    ripgrep \
    xdotool \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    dbus-x11 \
    libglib2.0-0 \
    psmisc \
    rofi \
    pdf2svg \
    rxvt-unicode

# Install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Build Neovim from source
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim \
    && cd /tmp/neovim \
    && git checkout stable \
    && make CMAKE_BUILD_TYPE=Release \
    && make install \
    && rm -rf /tmp/neovim

# Install Python support for Neovim
RUN pip3 install --upgrade pip \
    && pip3 install pynvim neovim-remote

# Install Node.js support for Neovim
RUN npm install -g neovim

# Install Ruby support for Neovim
RUN gem install neovim
RUN cpanm --force Neovim::Ext IO::Async MsgPack::Raw Eval::Safe 
RUN cpan App::cpanminus

RUN pip3 install --upgrade pip \
    && pip3 install \
        pynvim \
        neovim-remote \
        inkscape-figures \
        xlib
# ENV PATH="/opt/venv/bin:$PATH"

# Set environment variables required by neovim-remote
ENV NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Install inkscape shortcut manager 
RUN git clone https://github.com/gillescastel/inkscape-shortcut-manager.git /inkscape-shortcut-manager

# Manually download and install Russian spell files for Vim
RUN mkdir -p /root/.local/share/nvim/site/spell \
    && curl -fLo /root/.local/share/nvim/site/spell/ru.utf-8.spl \
        http://ftp.vim.org/vim/runtime/spell/ru.utf-8.spl \
    && curl -fLo /root/.local/share/nvim/site/spell/ru.utf-8.sug \
        http://ftp.vim.org/vim/runtime/spell/ru.utf-8.sug

# Install Vim-Plug
RUN curl -fLo "/root/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy config files
COPY ./config/ /root/.config/

# Install Neovim plugins
RUN nvim --headless +PlugInstall +qall

# This can be simplified???
VOLUME /tmp/.X11-unix
RUN apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y wget gnupg xvfb x11-xserver-utils python3-pip python-is-python3 \
# pulseaudio lxterminal \
 && pip3 install pyinotify python-uinput \
 && echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
 && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
 && apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y xpra \
 && mkdir -p /run/user/0/xpra

COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /home
ENTRYPOINT [ "/entrypoint.sh" ]
