FROM ruby:2.7
LABEL maintainer fpostoleh@gmail.com

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  locales \
  nodejs \
  sudo \
  libssl-dev \
  npm

RUN npm install npm@latest -g
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

RUN addgroup devel --gid 1000
RUN adduser devel --uid 1000 --gid 1000
RUN passwd -d devel
RUN usermod -aG sudo devel

USER devel

# Use en_US.UTF-8 as our locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN sudo mkdir -p /movie-wishes
RUN sudo chown devel:devel /movie-wishes
WORKDIR /movie-wishes

# RUN rails new . --database=postgresql --skip-git -T --api --webpack=react --skip-bundle
# Copy the Gemfile and install the RubyGems.
# This is a separate step so the dependencies
# will be cached unless changes to the file are made.
#COPY Gemfile Gemfile.lock ./
COPY --chown=devel:devel Gemfile ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
#COPY . ./
COPY --chown=devel:devel . ./

WORKDIR /movie-wishes/client
RUN npm install

WORKDIR /movie-wishes
# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
ENTRYPOINT ["bundle", "exec"]

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["rails", "server", "-b", "0.0.0.0"]
