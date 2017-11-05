FROM ruby:2.4.2

RUN apt-get update
RUN apt-get install nodejs -y

ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
ADD . $APP_HOME

WORKDIR $APP_HOME

RUN bundle install








