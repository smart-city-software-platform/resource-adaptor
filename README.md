![Build Status](https://gitlab.com/smart-city-platform/resource-adaptor/badges/master/build.svg)

# README

## Environment Setup

* Install RVM
* Run on terminal: ```$ rvm install 2.2.0```
* In the project directory, run:
  * ```$ gem install bundle```
  * ```$ bundle install```
  * ```$ bundle exec rake db:create```
  * ```$ bundle exec rake db:migrate```
* Run the tests:
  * ```$ rspec```

You should see all tests passing =)

## Configuration

### Database

We use a relational database to store some important information about all components encapsulated by a resource

By default, our [database config file](doc/config/database.yml) use the adpater for sqlite3 that is good enough for smal amount of transactions (or small number of simulated components). However, you can also configure a resource-adaptor to use more powerful alternatives, such as [PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-setup-ruby-on-rails-with-postgres) and
MySQL(https://www.digitalocean.com/community/tutorials/how-to-use-mysql-with-your-ruby-on-rails-application-on-ubuntu-14-04).

### Services links

Basicly, this app needs to know two external services:
* [Resources Catalog](https://gitlab.com/smart-city-platform/resources-catalog)
* [Data Collector](https://gitlab.com/smart-city-platform/data_collector)

The app also needs to know what its URL in order to properly register in the Smart City Platform.

To set the three required URL, edit the [services config file](doc/config/services.yml)

### Resource and Components

In order to automatically populate the database with resource and components data we recommend that you use the [resource config file](doc/config/resource.yml). See the [file](doc/config/resource.yml) to undestand how to add data.

You can also use alternative ways to populate the database with your informantion. You could add new fields or table by adding new migrations or create your own scripts to populate the database, for instance.
