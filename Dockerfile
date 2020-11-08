ARG ROOT_CONTAINER=ubuntu:20.10

ARG BASE_CONTAINER=$ROOT_CONTAINER
ARG NB_USER="jupyter"
ARG NB_UID="1000"
ARG NB_GID="100"
FROM $BASE_CONTAINER

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

ENV TZ=Pacific/Auckland
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER $NB_UID
WORKDIR $HOME

USER root
RUN apt-get update && apt-get install -yq --no-install-recommends build-essential emacs-nox vim-tiny git libsm6 libxext-dev libxrender1 lmodern netcat python-dev python3-pip jupyter texlive-xetex texlive-fonts-recommended texlive-plain-generic tzdata unzip nano && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install Pygments==2.6.1 pandas numpy matplotlib plotly scikit-learn beautifulsoup4 jupyter notebook
RUN mkdir -p /home/$NB_USER
COPY start /home/


EXPOSE 8888

CMD [ "/home/start" ]

USER $NB_UID

WORKDIR $HOME