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
# install google chrome
RUN apt-get update && apt-get install -y1 gnupg2
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN apt-get update && apt-get install -yqq unzip curl
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

RUN apt-get update && apt-get install -yq --no-install-recommends build-essential emacs-nox vim-tiny git libsm6 libxext-dev libxrender1 lmodern netcat python-dev python3-pip jupyter texlive-xetex texlive-fonts-recommended texlive-plain-generic tzdata unzip nano && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install Pygments==2.6.1 pandas numpy matplotlib plotly scikit-learn beautifulsoup4 jupyter notebook
RUN python3 -m pip install requests selenium
RUN python3 -m pip install mysql-connector-python
RUN python3 -m pip install feedparser spacy
RUN python3 -m spacy download en_core_web_lg
RUN mkdir -p /home/$NB_USER
COPY start /home/

# set display port to avoid crash
ENV DISPLAY=:99

EXPOSE 8888

CMD [ "/home/start" ]

USER $NB_UID

WORKDIR $HOME
