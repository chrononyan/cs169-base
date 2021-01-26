FROM ruby:2.7

RUN apt-get update && apt-get install -y --no-install-recommends git vim \
  && rm -rf /var/lib/apt/lists/*
RUN curl -sLo- https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz | tar -C /usr/local --strip-components 1 --anchored --exclude 'node-*-linux-x64/[A-Z]*' -xJf -
RUN curl -sLo- https://cli-assets.heroku.com/install.sh | sh
RUN gem install rails -v '~> 6'

RUN mkdir -p ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
# Hacks to bypass RVM requirement in saasbook/courseware:verify-setup.sh
RUN mkdir -p ~/.rvm/scripts && echo 'rvm() { echo "Using $(ruby -v)"; }\n\nexport -f rvm' > ~/.rvm/scripts/rvm && echo 'source $HOME/.rvm/scripts/rvm' >> ~/.bashrc

COPY --chmod=600 .ssh_key /root/.ssh/id_ed25519
ENV HEROKU_API_KEY=

WORKDIR /app
