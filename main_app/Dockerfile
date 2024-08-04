FROM ruby:3.1

RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:create db:migrate && bundle exec rails s -b '0.0.0.0'"]
