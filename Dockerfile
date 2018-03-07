FROM ruby:2.3

# Set up our Ruby environment - from ruby:2.0-onbuild
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/local/web-reader && mkdir -p /home/jenkins
WORKDIR /usr/local/web-reader

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

RUN gem install coffee-rails --no-document
# need export GEM_HOME='/usr/local/bundlbe'

# make it possible to deploy the built files
RUN apt-get install -y awscli
