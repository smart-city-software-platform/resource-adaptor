![Build Status](https://gitlab.com/smart-city-software-platform/resource-adaptor/badges/master/build.svg)

# README

The detailed documentation can be found in [the Wiki of this repository](https://gitlab.com/smart-city-software-platform/resource-adaptor/wikis/home).

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

## Docker Setup

* Install Docker: (google it)
* Run on terminal:
  * ```$ script/setup```
  * ```$ script/development start``` # start the container
  * ```$ script/development stop```  # stop the container

When the container is running you can access the application on
http://localhost:3002

To execute commands into the started container you can run:

```$ scripts/development exec <command>```

## Workaround

Please, try the following approaches to fix possible errors raised when 
trying to start docker services:

### Bind problem

If you have bind errors while trying to start a docker service, try
to remove the docker-network **platform** and create it again. If this not fix
the problem, run the following commands:

* Stop docker deamon: ```sudo service docker stop```
* Remova o arquivo local-kv: ```sudo rm /var/lib/docker/network/files/local-kv.db```
* Start docker deamon: ```sudo service docker start```
* Create the network again: ```sudo docker network create platform```
* Run the container: ```./script/development start```

### Name problem

If get any name conflicts while trying to run a docker container, try to 
follow these steps:

* Stop current container: ```./script/development stop```
* Start the container: ```./script/development start```

## Configuration

### Database

We use a relational database to store some important information about all components encapsulated by a resource.

By default, our [database config file](config/database.yml) use the adpater for postgresql.

### Services links

Basically, this app needs to know two external services:
* [Resources Cataloguer](https://gitlab.com/smart-city-software-platform/resource-cataloguer)
* [Data Collector](https://gitlab.com/smart-city-software-platform/data-collector)

The app also needs to know what its URL in order to properly register in the Smart City Platform.

To set the three required URL, edit the [services config file](config/services.yml).

### Resource and Components

In order to automatically populate the database with resource and components 
data we recommend that you use the following method:

* Create components data through seed files. See the
[existing seed files](lib/seeds/) to understand hot to create your own script.
After this, run the task to create components in database:
    * To run all seed files: ```$ bundle exec rake component:seed```
    * To run a specific seed file: ```$ bundle exec rake component:seed[my_file_name.rb]```

You can also use alternative ways to populate the database with your
informantion. You could add new fields or table by adding new migrations 
or create your own scripts to populate the database, for instance.

### Data collection

We create a thread to perform data collection by each of existing components in database. 
To properly start data collection, the following steps must be performed:

* Running rails server: The data collection starts when you make the first a request to Resource Adaptor's API
* Running rails console: You must start data collection by yourself on console with ```$ ComponentsManager.instance.start_all```
* **Deprecated** - Use the collect data script manager: Run on project root ```$ rails runner scripts/collect.rb```
