FROM ubuntu
MAINTAINER Yoshiya Hinosawa <stibium121@gmail.com>

# First, get curl
RUN apt-get update && apt-get install -y curl

# Add Google’s Linux Package Signing Key
RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Add repository
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list

# Install xvfb and browsers
RUN apt-get update && apt-get install -y xvfb firefox google-chrome-stable && apt-get clean

#add user node and use it to install node/npm and run the app
RUN useradd --home /home/node -m -U -s /bin/bash node

#allow some limited sudo commands for user `node`
RUN echo 'Defaults !requiretty' >> /etc/sudoers; \
    echo 'node ALL= NOPASSWD: /usr/sbin/dpkg-reconfigure -f noninteractive tzdata, /usr/bin/tee /etc/timezone, /bin/chown -R node\:node /myapp' >> /etc/sudoers;

#run all of the following commands as user node from now on
USER node

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

#change it to your required node version
ENV NODE_VERSION 5.1.1

#needed by nvm install
ENV NVM_DIR /home/node/.nvm

#install the specified node version and set it as the default one, install the global npm packages
RUN . ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION

ADD npm-run.sh /npm-run.sh

ENTRYPOINT ["/bin/bash", "/npm-run.sh"]

CMD ["test"]
