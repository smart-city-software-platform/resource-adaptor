![Build Status](https://gitlab.com/smart-city-platform/resource-adaptor/badges/master/build.svg)

# README

The detailed documentation can be found in [Smart City Platform's Stoa page](https://social.stoa.usp.br/poo2016/forum-projeto-cidades-inteligentes/resource-adaptor).

## Environment Setup

* Install [PostgreSQL](https://www.postgresql.org/download/)
* Run on terminal: ```$ sudo -u postgres psql```
* Run on postgresql command line: ```$ create role resource_adaptor with createdb login password 'resource_adaptor';```
* Install RVM
* Run on terminal: ```$ rvm install 2.2.0```
* In the project directory, run:
  * ```$ gem install rails-api```
  * ```$ gem install bundle```
  * ```$ bundle install```
  * ```$ bundle exec rake db:create```
  * ```$ bundle exec rake db:migrate```
* Run the tests:
  * ```$ rspec```

You should see all tests passing =)

## Configuration

### Database

We use a relational database to store some important information about all components encapsulated by a resource.

By default, our [database config file](config/database.yml) use the adpater for postgresql.

### Services links

Basically, this app needs to know two external services:
* [Resources Catalog](https://gitlab.com/smart-city-platform/resources-catalog)
* [Data Collector](https://gitlab.com/smart-city-platform/data_collector)

The app also needs to know what its URL in order to properly register in the Smart City Platform.

To set the three required URL, edit the [services config file](config/services.yml).

### Resource and Components

In order to automatically populate the database with resource and components data we recommend that you use the one of the following methods:

* Create components data through [resource config file](config/resource.yml). See the [file](config/resource.yml) to undestand how to add data. After this, run the task to create components in database:

```$ bundle exec rake component:create```

* Create components data through seed files. See the [existing seed files](lib/seeds/) to understand hot to create your own script. After this, run the task to create components in database:
** To run all seed files: ```$ bundle exec rake component:seed```
** To run a specific seed file: ```$ bundle exec rake component:seed[my_file_name.rb]```

You can also use alternative ways to populate the database with your informantion. You could add new fields or table by adding new migrations or create your own scripts to populate the database, for instance.

