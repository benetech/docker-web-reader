ARG JAVA_UPDATE=144

FROM 814633283276.dkr.ecr.us-east-1.amazonaws.com/java:8u${JAVA_UPDATE}-jre as JRE
ARG JAVA_UPDATE
FROM ruby:2.1
ARG JAVA_UPDATE

ARG JRE_PATH=/opt/jre1.8.0_${JAVA_UPDATE}

COPY --from=JRE $JRE_PATH $JRE_PATH

ENV PATH=${JRE_PATH}/bin:$PATH

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
RUN apt-get update \
    && apt-get install -qy python-dev python-pip node.js zip \
    && pip install awscli

