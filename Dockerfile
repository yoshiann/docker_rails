FROM ruby:2.7

ENV DOCKERIZE_VERSION v0.6.1

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq \
    && apt-get install -y nodejs yarn 

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /docker_rails
COPY Gemfile /docker_rails/Gemfile
COPY Gemfile.lock /docker_rails/Gemfile.lock
RUN bundle install
COPY . /docker_rails

RUN bundle config --local set path 'vendor/bundle' \
    && bundle install

#RUN RAILS_ENV=${RAILS_ENV} bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]