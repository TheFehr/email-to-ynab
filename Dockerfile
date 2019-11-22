FROM ruby:2.6

RUN mkdir /app
WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN gem install bundler -v 2.0.2
RUN bundle install -j 8

ADD . /app

ENTRYPOINT ["ruby", "adapter.rb"]
CMD ["push"]

