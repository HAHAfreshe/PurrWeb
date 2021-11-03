FROM ruby:3.0

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY src/battleships.rb ./

CMD ["ruby", "battleships.rb"]