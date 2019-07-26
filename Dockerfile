FROM ruby:2.5

ENV APP_HOME /app
ENV HOME /root
RUN mkdir ${APP_HOME} 

COPY Gemfile ${APP_HOME}/
WORKDIR ${APP_HOME}/

RUN bundle install
RUN apt-get update

COPY main.rb ${APP_HOME}
COPY testing.yml ${APP_HOME}/

CMD ["bundle", "exec", "/app/main.rb", "./config.yml"]