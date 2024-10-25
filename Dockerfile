FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    texlive-full \
    zathura

RUN apt-get install -y neovim

WORKDIR /app

# .bashrc
COPY ./config/bashrc_modification.sh /app
RUN cat /app/bashrc_modification.sh >> /root/.bashrc

RUN echo "alias vi='nvim'" >> ~/.bashrc
RUN echo "alias vim='nvim'" >> ~/.bashrc

CMD [ "/bin/bash" ]

