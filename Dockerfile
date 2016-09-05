FROM debian:unstable
RUN apt update -qy && apt install ruby bundler libxml2 libsqlite3-dev libpq-dev postgresql postgresql-contrib -yq
RUN mkdir -p /resource-adaptor/
ADD . /resource-adaptor/
WORKDIR /resource-adaptor/
RUN bundle install
RUN RAILS_ENV=development bundle exec rake db:create
RUN RAILS_ENV=development bundle exec rake db:migrate
EXPOSE 3000
CMD ["bundle","exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]
