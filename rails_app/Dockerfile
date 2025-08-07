FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV GROVER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
ENV CHROME_BIN=/usr/bin/google-chrome-stable

# Install system dependencies
RUN apt-get update && apt-get install -y \
  curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev \
  libxml2-dev libxslt1-dev \
  sudo git autoconf bison libyaml-dev libsqlite3-dev sqlite3 libgdbm-dev \
  libncurses5-dev libffi-dev libgmp-dev libpq-dev libtool pkg-config \
  nodejs npm libvips libvips-dev \
  libxshmfence1 libglu1-mesa libdrm2 libxkbcommon0 libgbm-dev libxdamage1 \
  libnss3 libatk-bridge2.0-0 libatk1.0-0 libx11-xcb1 libxcomposite1 \
  libxrandr2 libasound2t64 libxss1 libgtk-3-0 fonts-liberation xdg-utils \
  xvfb  # Required for headless Chrome

# Install Yarn
RUN npm install -g yarn

# Install Google Chrome
RUN apt-get update && apt-get install -y wget gnupg \
  && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get install -y google-chrome-stable \
  && rm -rf /var/lib/apt/lists/*

# Verify Chrome installation
RUN ls -la /usr/bin/google* && \
    google-chrome-stable --version && \
    which google-chrome-stable

# Create hosting user
RUN useradd -m -s /bin/bash hosting && \
    echo 'hosting ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hosting

USER hosting
WORKDIR /home/hosting

# Install RVM and Ruby
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

ENV PATH="/home/hosting/.rvm/bin:$PATH" \
    GEM_HOME="/home/hosting/.rvm/gems/ruby-3.2.2" \
    GEM_PATH="/home/hosting/.rvm/gems/ruby-3.2.2:/home/hosting/.rvm/gems/ruby-3.2.2@global"

RUN bash -lc "rvm install 3.2.2 && \
    rvm use 3.2.2 --default && \
    gem install bundler rails"

RUN echo 'source /home/hosting/.rvm/scripts/rvm' >> /home/hosting/.bashrc

# Set up application
WORKDIR /home/hosting/app

# Ensure tmp directory exists with correct permissions
RUN mkdir -p tmp/pdfs && chmod -R 777 tmp

COPY --chown=hosting:hosting Gemfile Gemfile.lock ./

RUN chmod -R u+w /home/hosting/app && \
    bash -lc "bundle install"

COPY --chown=hosting:hosting . .

# Final Chrome verification and health check
RUN google-chrome-stable --version