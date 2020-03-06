FROM ubuntu:bionic
LABEL maintainer="Shaun Jackman <sjackman@gmail.com>"
LABEL name="linuxbrew/bionic"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl file g++ git locales make uuid-runtime \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && useradd -m -s /bin/bash linuxbrew \
    && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
WORKDIR /home/linuxbrew
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
    SHELL=/bin/bash

RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew \
    && mkdir /home/linuxbrew/.linuxbrew/bin \
    && ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/ \
    && brew config


RUN brew update

# RUN brew install cmake
# RUN brew install openssh

RUN brew install apache-flink

WORKDIR  /home/linuxbrew/.linuxbrew/Cellar/apache-flink/1.9.1/

COPY bin  bin

COPY conf  conf

COPY lib  lib

COPY examples  examples

COPY opt  opt

COPY plugins  plugins

RUN mkdir /tmp/log

EXPOSE 8081

ENTRYPOINT  ./bin/start-cluster.sh start-foreground; ./bin/flink run ./examples/batch/WordCount.jar & sleep 3600;

# ENTRYPOINT  ./bin/start-local.sh; sleep 3600;

